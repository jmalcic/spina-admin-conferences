# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class RoomImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Room.transaction do
            rows.collect do |row|
              institution = find_institution row[:institution]
              Room.create! building: row[:building], number: row[:number], institution: institution
            end
          end
        end
      end
    end
  end
end
