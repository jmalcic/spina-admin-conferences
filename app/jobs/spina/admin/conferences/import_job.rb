# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
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
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date json]
        end

        def find_institution(params)
          Institution.find_by! name: params[:name], city: params[:city]
        end

        def find_room(params)
          Room.find_by! building: params[:building], number: params[:number],
                        institution: find_institution(params[:institution])
        end

        def find_rooms(params)
          params.collect { |room| find_room room }
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
          params.collect { |conference| find_conference conference }
        end

        def find_room_possession(params)
          conference = find_conference(params[:conference])
          params[:room][:institution] = conference.institution
          room = find_room params[:room]
          RoomPossession.find_by! room: room, conference: conference
        end

        def find_room_possessions(params)
          params.collect { |room_possession| find_room_possession(room_possession) }
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
          params[:presentation_type][:conference] = params[:conference]
          params[:room_possession][:conference] = params[:conference]
          RoomUse.find_by! presentation_type: find_presentation_type(params[:presentation_type]),
                           room_possession: find_room_possession(params[:room_possession])
        end
      end
    end
  end
end
