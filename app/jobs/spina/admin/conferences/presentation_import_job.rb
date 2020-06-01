# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports presentations from CSV files
      class PresentationImportJob < ImportJob
        queue_as :default

        def perform(csv)
          Presentation.transaction do
            import(csv) do |row|
              session = row[:session]
              copy_value :conference, from: row, to: session
              Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                   abstract: row[:abstract], presenters: find_delegates(row[:presenters]),
                                   session: find_session(session)
            end
          end
        end
      end
    end
  end
end
