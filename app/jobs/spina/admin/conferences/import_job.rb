# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # Job for importing CSV files.
      class ImportJob < ApplicationJob
        CSV::Converters[:json] = lambda do |field|
          JSON.parse field, symbolize_names: true
        rescue JSON::ParserError
          field
        end

        # Performs the job.
        # @param file [String] the UTF-8-encoded string to parse as a CSV
        # @yieldparam row [Hash] the current row of the CSV
        def import(file)
          csv_rows = CSV.parse file, encoding: 'UTF-8', headers: true, header_converters: :symbol, converters: [:json]
          csv_rows.each { |row| yield(row) }
        end
      end
    end
  end
end
