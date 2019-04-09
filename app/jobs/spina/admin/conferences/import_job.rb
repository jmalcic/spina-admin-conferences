# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports CSV files
      class ImportJob < ApplicationJob
        include ::Spina::Conferences

        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol, converters: %i[date_time date]
        end

        def find_institution(params)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          Institution.find_by! name: params[:name], city: params[:city]
        end

        def find_room(params, with_institution: nil)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          institution = with_institution || find_institution(room[:institution])
          Room.find_by! building: params[:building], number: params[:number], institution: institution
        end

        def find_rooms(params, with_institution: nil)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          params.collect do |room|
            institution = with_institution || find_institution(room[:institution])
            find_room room, with_institution: institution
          end
        end

        def find_dietary_requirements(params)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          params.collect do |dietary_requirement|
            DietaryRequirement.find_by! name: dietary_requirement[:name]
          end
        end

        def find_conference(params)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          Conference.find_by! institution: find_institution(params[:institution]),
                              dates: params[:start_date]..params[:finish_date]
        end

        def find_conferences(params)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          params.collect { |conference| find_conference conference }
        end

        def find_room_possession(params, with_conference: nil)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          conference = with_conference || find_conference(room_possession[:conference])
          room = find_room params[:room], with_institution: conference.institution
          RoomPossession.find_by! room: room, conference: conference
        end

        def find_room_possessions(params, with_conference: nil)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          params.collect do |room_possession|
            conference = with_conference || find_conference(room_possession[:conference])
            find_room_possession room_possession, with_conference: conference
          end
        end

        def find_presentation_type(params, with_conference: nil)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          conference = with_conference || find_conference(params[:conference])
          PresentationType.find_by! conference: conference, name: params[:name]
        end

        def find_delegates(params)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          params.collect do |presenter|
            Delegate.find_by! first_name: presenter[:first_name], last_name: presenter[:last_name],
                              institution: find_institution(presenter[:institution])
          end
        end

        def find_room_use(params, with_conference: nil)
          params = JSON.parse(params, symbolize_names: true) if params.is_a?(String)
          conference = with_conference || find_conference(params[:conference])
          presentation_type = find_presentation_type params[:presentation_type], with_conference: conference
          room_possession = find_room_possession params[:room_possession], with_conference: conference
          RoomUse.find_by! presentation_type: presentation_type, room_possession: room_possession
        end
      end
    end
  end
end
