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
              dietary_requirements = find_dietary_requirements row[:dietary_requirements]
              institution = find_institution row[:institution]
              conferences = find_conferences row[:conferences]
              Delegate.create! first_name: row[:first_name], last_name: row[:last_name],
                               institution: institution, email_address: row[:email_address],
                               dietary_requirements: dietary_requirements, conferences: conferences
            end
          end
        end
      end
    end
  end
end
