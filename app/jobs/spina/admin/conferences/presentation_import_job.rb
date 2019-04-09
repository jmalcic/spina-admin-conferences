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
              row[:room_use][:conference] = row[:conference]
              Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                   abstract: row[:abstract], presenters: find_delegates(row[:presenters]),
                                   room_use: find_room_use(row[:room_use])
            end
          end
        end
      end
    end
  end
end
