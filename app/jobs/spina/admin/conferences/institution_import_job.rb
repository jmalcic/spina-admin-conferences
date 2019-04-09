# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports institutions from CSV files
      class InstitutionImportJob < ImportJob
        include ::Spina::Conferences

        queue_as :default

        def perform(csv)
          rows = import csv
          Institution.transaction do
            rows.collect do |row|
              Institution.create! name: row[:name], city: row[:city], rooms_attributes: row[:rooms]
            end
          end
        end
      end
    end
  end
end
