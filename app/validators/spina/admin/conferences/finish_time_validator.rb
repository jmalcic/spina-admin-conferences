# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Validator for times which should occur after a +start_time+.
      class FinishTimeValidator < ActiveModel::EachValidator
        # Performs validation on the supplied record.
        # @param record [ActiveRecord::Base] the associated record
        # @param attribute [Symbol] the attribute key
        # @param value [Time] the attribute value
        def validate_each(record, attribute, value)
          return if value.blank? || value >= record.start_time

          record.errors.add(attribute, :before_start_time)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
