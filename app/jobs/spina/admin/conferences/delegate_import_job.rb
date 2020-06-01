# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class DelegateImportJob < ImportJob
        queue_as :default

        def perform(csv)
          import(csv) do |row|
            Delegate.transaction do
              institution = Institution.i18n.find_by(row[:institution])
              dietary_requirements = DietaryRequirement.i18n.where(name: row[:dietary_requirements])
              conferences = row[:conferences].collect { |params| Conference.i18n.find_by(params) }
              Delegate.create! first_name: row[:first_name], last_name: row[:last_name],
                               email_address: row[:email_address], institution: institution,
                               dietary_requirements: dietary_requirements, conferences: conferences
            end
          end
        end
      end
    end
  end
end
