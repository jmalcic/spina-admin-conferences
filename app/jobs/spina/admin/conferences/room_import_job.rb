# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class RoomImportJob < ApplicationJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Room.transaction do
            rows.collect do |row|
              Room.create! building: row[:building], number: row[:number], institution: find_institution(row)
            end
          end
        end

        def find_institution(row)
          Institution.find_by! name: row[:institution_name], city: row[:institution_city]
        end

        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date]
        end
      end
    end
  end
end
