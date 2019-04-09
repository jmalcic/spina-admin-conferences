# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class DelegateImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Delegate.transaction do
            rows.collect do |row|
              Delegate.create! first_name: row[:first_name], last_name: row[:last_name],
                               email_address: row[:email_address], institution: find_institution(row[:institution]),
                               dietary_requirements: find_dietary_requirements(row[:dietary_requirements]),
                               conferences: find_conferences(row[:conferences])
            end
          end
        end
      end
    end
  end
end
