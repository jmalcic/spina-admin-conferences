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
              row[:rooms].each { |room| room[:institution] = row[:institution] }
              Conference.create! institution: find_institution(row[:institution]),
                                 dates: row[:start_date]..row[:finish_date], rooms: find_rooms(row[:rooms])
            end
          end
        end
      end
    end
  end
end
