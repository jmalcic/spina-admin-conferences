# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class DietaryRequirementImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          @rows = import csv
          DietaryRequirement.transaction do
            @rows.collect do |row|
              DietaryRequirement.create! name: row[:name]
            end
          end
        end
      end
    end
  end
end
