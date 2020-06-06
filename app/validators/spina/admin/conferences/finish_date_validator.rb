# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Validator for dates which should occur after a +start_date+.
      class FinishDateValidator < ActiveModel::EachValidator
        # Performs validation on the supplied record.
        # @param record [ActiveRecord::Base] the associated record
        # @param attribute [Symbol] the attribute key
        # @param value [Date] the attribute value
        def validate_each(record, attribute, value)
          return if value.blank? || value >= record.start_date

          record.errors.add(attribute, :before_start_date)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
