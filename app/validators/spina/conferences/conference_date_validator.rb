# frozen_string_literal: true

module Spina
  module Conferences
    # This class validates the date of an object to make sure it occurs during
    # the associated conference.
    class ConferenceDateValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if value.blank? || (record&.conference&.dates&.cover? value.to_date)
    
        record.errors.add(attribute, :outside_conference)
      end
    end
  end
end
