# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports institutions from CSV files
    class InstitutionImportJob < ImportJob
      queue_as :default

      def perform(csv)
        Institution.transaction do
          import(csv) do |row|
            Institution.create! name: row[:name], city: row[:city], rooms_attributes: row[:rooms]
          end
        end
      end
    end
  end
end
