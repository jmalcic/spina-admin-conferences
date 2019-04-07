# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class DelegateImportJob < ApplicationJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Delegate.transaction do
            rows.collect do |row|
              Delegate.create! first_name: row[:first_name], last_name: row[:last_name],
                               institution: find_institution(row), email_address: row[:email_address],
                               conferences: find_conferences(row), dietary_requirements: find_dietary_requirements(row)
            end
          end
        end

        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date]
        end

        def find_institution(row)
          Institution.find_or_create_by! name: row[:institution_name], city: row[:institution_city]
        end

        def find_conference_institution(institution)
          Institution.find_by! name: institution['name'], city: institution['city']
        end

        def find_conferences(row)
          conferences = ActiveSupport::JSON.decode(row[:conferences])
          conferences.collect do |conference|
            Conference.find_by! institution: find_conference_institution(conference['institution']),
                                dates: conference['start_date']..conference['finish_date']
          end
        end

        def find_dietary_requirements(row)
          dietary_requirements = ActiveSupport::JSON.decode(row[:dietary_requirements])
          dietary_requirements.collect do |dietary_requirement|
            DietaryRequirement.find_by! name: dietary_requirement['name']
          end
        end
      end
    end
  end
end
