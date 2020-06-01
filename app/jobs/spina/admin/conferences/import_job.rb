# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports CSV files
      class ImportJob < ApplicationJob
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
          Institution.i18n.find_by! name: params[:name], city: params[:city]
        end

        def find_room(params)
          Room.i18n.find_by! building: params[:building], number: params[:number],
                             institution: find_institution(params[:institution])
        end

        def find_rooms(params)
          params.collect(&method(:find_room))
        end

        def find_dietary_requirements(params)
          params.collect do |dietary_requirement|
            DietaryRequirement.i18n.find_by! name: dietary_requirement[:name]
          end
        end

        def find_conference(params)
          Conference.i18n.find_by! name: params[:name], dates: params[:start_date]..params[:finish_date]
        end

        def find_conferences(params)
          params.collect(&method(:find_conference))
        end

        def find_presentation_type(params)
          PresentationType.i18n.find_by! conference: find_conference(params[:conference]), name: params[:name]
        end

        def find_delegates(params)
          params.collect do |presenter|
            Delegate.find_by! first_name: presenter[:first_name], last_name: presenter[:last_name],
                              institution: find_institution(presenter[:institution])
          end
        end

        def find_session(params)
          presentation_type_params = params[:presentation_type]
          room_params = params[:room]
          copy_value :conference, from: params, to: presentation_type_params
          Session.find_by presentation_type: find_presentation_type(presentation_type_params),
                          room: find_room(room_params)
        end

        def copy_value(value, from: nil, to: nil)
          return unless from.present? && to.present?

          source = from[value]
          to.is_a?(Array) ? to.each { |element| element[value] = source } : to[value] = source
        end
      end
    end
  end
end
