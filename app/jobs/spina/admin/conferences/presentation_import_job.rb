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
              presenters = find_delegates row[:presenters]
              conference = find_conference row[:conference]
              room_use = find_room_use row[:room_use], with_conference: conference
              Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                   abstract: row[:abstract], room_use: room_use, presenters: presenters
            end
          end
        end
      end
    end
  end
end
