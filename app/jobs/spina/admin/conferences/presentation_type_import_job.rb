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
              row[:room_possessions].each { |room_possession| room_possession[:conference] = row[:conference] }
              PresentationType.create! name: row[:name], minutes: row[:minutes],
                                       conference: find_conference(row[:conference]),
                                       room_possessions: find_room_possessions(row[:room_possessions])
            end
          end
        end
      end
    end
  end
end
