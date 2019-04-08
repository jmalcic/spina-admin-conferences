# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports conferences from CSV files
      class ConferenceImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Conference.transaction do
            rows.collect do |row|
              Conference.create! institution: find_institution(row), dates: row[:start_date]..row[:finish_date],
                                 rooms: find_rooms(row)
            end
          end
        end

        def find_institution(row)
          Institution.find_by! name: row[:institution_name], city: row[:institution_city]
        end

        def find_rooms(row)
          rooms = ActiveSupport::JSON.decode(row[:rooms])
          rooms.collect do |room|
            Room.find_by! building: room['building'], number: room['number'], institution: find_institution(row)
          end
        end
      end
    end
  end
end
