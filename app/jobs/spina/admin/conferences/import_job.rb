# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports CSV files
      class ImportJob < ApplicationJob
        CSV::Converters[:json] = lambda do |field|
          JSON.parse field, symbolize_names: true
        rescue JSON::ParserError
          field
        end

        def import(file)
          csv_rows = CSV.parse file, encoding: 'UTF-8', headers: true, header_converters: :symbol, converters: [:json]
          csv_rows.collect { |row| yield(row) }
        end
      end
    end
  end
end
