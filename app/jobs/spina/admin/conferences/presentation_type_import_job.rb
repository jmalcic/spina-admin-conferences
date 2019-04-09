# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports presentation types from CSV files
      class PresentationTypeImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          PresentationType.transaction do
            rows.collect do |row|
              conference = find_conference row[:conference], from_json: true
              room_possessions = find_room_possessions row[:room_possessions], from_json: true,
                                                                               with_conference: conference
              PresentationType.create! name: row[:name], minutes: row[:minutes], conference: conference,
                                       room_possessions: room_possessions
            end
          end
        end
      end
    end
  end
end
