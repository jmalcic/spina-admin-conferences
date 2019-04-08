# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports presentations from CSV files
      class PresentationImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Presentation.transaction do
            rows.collect do |row|
              Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                   abstract: row[:abstract], room_use: find_room_use(row),
                                   presenters: find_presenters(row)
            end
          end
        end

        def find_conference_institution(row)
          Institution.find_by! name: row[:conference_institution], city: row[:conference_city]
        end

        def find_conference(row)
          Conference.find_by! institution: find_conference_institution(row),
                              dates: row[:conference_start_date]..row[:conference_end_date]
        end

        def find_presentation_type(row)
          PresentationType.find_by! conference: find_conference(row), name: row[:presentation_type]
        end

        def find_room(row)
          Room.find_by! building: row[:building], number: row[:number], institution: find_conference_institution(row)
        end

        def find_room_possession(row)
          RoomPossession.find_by! conference: find_conference(row), room: find_room(row)
        end

        def find_room_use(row)
          RoomUse.find_by! presentation_type: find_presentation_type(row),
                           room_possession: find_room_possession(row)
        end

        def find_delegate_institution(institution)
          Institution.find_by! name: institution['name'], city: institution['city']
        end

        def find_presenters(row)
          presenters = ActiveSupport::JSON.decode(row[:presenters])
          presenters.collect do |presenter|
            Delegate.find_by! first_name: presenter['first_name'], last_name: presenter['last_name'],
                              institution: find_delegate_institution(presenter['institution'])
          end
        end
      end
    end
  end
end
