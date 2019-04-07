# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class DietaryRequirementImportJob < ApplicationJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          DietaryRequirement.transaction do
            rows.collect do |row|
              DietaryRequirement.create! name: row[:name]
            end
          end
        end

        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date]
        end
      end
    end
  end
end
