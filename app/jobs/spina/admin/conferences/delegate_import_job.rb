# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Job for importing {Delegate} objects.
      # @see Delegate
      class DelegateImportJob < ImportJob
        queue_as :default

        # Performs the job.
        # @param csv [String] the UTF-8-encoded string to parse as a CSV
        #   == Columns
        #   The CSV should has the following columns. Make sure to include the column names in the header row.
        #   +first_name+:: The first name of the delegate.
        #   +last_name+:: The last name of the delegate.
        #   +email_address+:: The email address of the delegate.
        #   +institution+:: The current institution of the delegate, formatted as JSON.
        #   +dietary_requirements+:: The dietary requirements of the delegate, formatted as JSON.
        #
        #   == JSON columns
        #
        #   === +institution+
        #   A JSON object containing the institution's attributes (attributes will be looked up assuming the default locale).
        #   See the example below.
        #     {
        #       "name": "University of Shangri-La",
        #       "city": "Atlantis"
        #     }
        #
        #   === +dietary_requirements+
        #   A JSON array of dietary requirement names (the names will be looked up assuming the default locale). See the example below.
        #     ["vegan", "halal"]
        #
        # @return [void]
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
