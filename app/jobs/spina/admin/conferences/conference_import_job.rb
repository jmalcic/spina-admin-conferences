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
              Conference.create! name: row[:name], start_date: row[:start_date], finish_date: row[:finish_date]
            end
          end
        end
      end
    end
  end
end
