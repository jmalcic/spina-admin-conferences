# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Validator for dates which should occur during the associated conference.
      class ConferenceDateValidator < ActiveModel::EachValidator
        # Performs validation on the supplied record.
        # @param record [ActiveRecord::Base] the associated record
        # @param attribute [Symbol] the attribute key
        # @param value [Date] the attribute value
        def validate_each(record, attribute, value)
          return if value.blank? || record.conference&.dates&.cover?(value.to_date)

          record.errors.add(attribute, :outside_conference)
        end
      end
    end
  end
end
