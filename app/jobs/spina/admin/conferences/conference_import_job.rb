# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports conferences from CSV files
      class ConferenceImportJob < ImportJob
        queue_as :default

        def perform(csv)
          Conference.transaction do
            import(csv) do |row|
              rooms = row[:rooms]
              Conference.create! name: row[:name], start_date: row[:start_date], finish_date: row[:finish_date], rooms: find_rooms(rooms)
            end
          end
        end
      end
    end
  end
end
