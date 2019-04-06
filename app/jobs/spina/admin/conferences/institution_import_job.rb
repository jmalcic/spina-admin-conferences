# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports institutions from CSV files
      class InstitutionImportJob < ApplicationJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Institution.transaction do
            rows.collect do |row|
              Institution.create! name: row[:name], city: row[:city], rooms_attributes: decode_rooms(row)
            end
          end
        end

        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date]
        end

        def decode_rooms(row)
          rooms = ActiveSupport::JSON.decode(row[:rooms])
          rooms.collect { |room| { building: room['building'], number: room['number'] } }
        end
      end
    end
  end
end
