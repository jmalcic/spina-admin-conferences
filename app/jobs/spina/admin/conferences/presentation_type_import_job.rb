# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports presentation types from CSV files
      class PresentationTypeImportJob < ApplicationJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          PresentationType.transaction do
            rows.collect do |row|
              PresentationType.create! name: row[:name], minutes: row[:minutes],
                                       conference: find_conference(row), room_possessions: find_room_possessions(row)
            end
          end
        end

        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date]
        end

        def find_institution(row)
          Institution.find_by! name: row[:conference_institution_name], city: row[:conference_institution_city]
        end

        def find_conference(row)
          Conference.find_by! institution: find_institution(row),
                              dates: row[:conference_start_date]..row[:conference_finish_date]
        end

        def find_rooms(row)
          rooms = ActiveSupport::JSON.decode(row[:rooms])
          rooms.collect do |room|
            Room.find_by! building: room['building'], number: room['number'], institution: find_institution(row)
          end
        end

        def find_room_possessions(row)
          rooms = find_rooms(row)
          rooms.collect do |room|
            RoomPossession.find_by! room: room, conference: find_conference(row)
          end
        end
      end
    end
  end
end
