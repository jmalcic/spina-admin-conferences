# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports conferences from CSV files
      class ConferenceImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          Conference.transaction do
            import(csv) do |row|
              rooms = row[:rooms]
              copy_value :institution, from: row, to: rooms
              Conference.create! institution: find_institution(row[:institution]), dates: row[:start_date]..row[:finish_date],
                                 rooms: find_rooms(rooms)
            end
          end
        end
      end
    end
  end
end
