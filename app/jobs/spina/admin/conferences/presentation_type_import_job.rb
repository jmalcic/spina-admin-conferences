# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports presentation types from CSV files
      class PresentationTypeImportJob < ImportJob
        queue_as :default

        def perform(csv)
          PresentationType.transaction do
            import(csv) do |row|
              PresentationType.create! name: row[:name], minutes: row[:minutes],
                                       conference: find_conference(row[:conference])
            end
          end
        end
      end
    end
  end
end
