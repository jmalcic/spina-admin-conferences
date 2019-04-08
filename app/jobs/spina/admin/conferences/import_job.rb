# frozen_string_literal: true

require 'csv'

module Spina
  module Admin
    module Conferences
      # This job imports CSV files
      class ImportJob < ApplicationJob
        def import(csv)
          CSV.parse csv, encoding: 'UTF-8', headers: true, header_converters: :symbol,
                         converters: %i[date_time date]
        end
      end
    end
  end
end
