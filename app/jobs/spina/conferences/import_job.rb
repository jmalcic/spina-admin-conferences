# frozen_string_literal: true

require 'csv'

module Spina
  module Conferences
    # This job imports CSV files
    class ImportJob < ApplicationJob
      include ::Spina::Conferences

      CSV::Converters[:json] = lambda do |field|
        JSON.parse field, symbolize_names: true
      rescue JSON::ParserError
        field
      end

      def import(csv)
        CSV.parse(csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                       converters: %i[date_time date json]).collect { |row| yield(row) }
      end

      def find_institution(params)
        Institution.find_by! name: params[:name], city: params[:city]
      end

      def find_room(params)
        Room.find_by! building: params[:building], number: params[:number],
                      institution: find_institution(params[:institution])
      end

      def find_rooms(params)
        params.collect(&method(:find_room))
      end

      def find_dietary_requirements(params)
        params.collect do |dietary_requirement|
          DietaryRequirement.find_by! name: dietary_requirement[:name]
        end
      end

      def find_conference(params)
        Conference.find_by! institution: find_institution(params[:institution]),
                            dates: params[:start_date]..params[:finish_date]
      end

      def find_conferences(params)
        params.collect(&method(:find_conference))
      end

      def find_room_possession(params)
        conference = find_conference(params[:conference])
        room_params = params[:room]
        room_params[:institution] = conference.institution
        RoomPossession.find_by! room: find_room(room_params), conference: conference
      end

      def find_room_possessions(params)
        params.collect(&method(:find_room_possession))
      end

      def find_presentation_type(params)
        PresentationType.find_by! conference: find_conference(params[:conference]), name: params[:name]
      end

      def find_delegates(params)
        params.collect do |presenter|
          Delegate.find_by! first_name: presenter[:first_name], last_name: presenter[:last_name],
                            institution: find_institution(presenter[:institution])
        end
      end

      def find_room_use(params)
        presentation_type_params = params[:presentation_type]
        room_possession_params = params[:room_possession]
        copy_value :conference, from: params, to: presentation_type_params
        copy_value :conference, from: params, to: room_possession_params
        RoomUse.find_by! presentation_type: find_presentation_type(presentation_type_params),
                         room_possession: find_room_possession(room_possession_params)
      end

      def copy_value(value, from: nil, to: nil)
        return unless from.present? && to.present?

        source = from[value]
        to.is_a?(Array) ? to.each { |element| element[value] = source } : to[value] = source
      end
    end
  end
end
