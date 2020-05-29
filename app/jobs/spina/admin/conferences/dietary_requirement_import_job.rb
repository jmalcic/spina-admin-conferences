# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports rooms from CSV files
      class DietaryRequirementImportJob < ImportJob
        queue_as :default

        def perform(csv)
          DietaryRequirement.transaction do
            import(csv) do |row|
              DietaryRequirement.create! name: row[:name]
            end
          end
        end
      end
    end
  end
end
