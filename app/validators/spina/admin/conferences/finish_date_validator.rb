# frozen_string_literal: true

module Spina
  module Admin
  module Conferences
    # This class validates the finish date of an object to make sure it occurs
    # after the start date.
    class FinishDateValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute, :before_start_date) unless value.blank? || value >= record.start_date
      end
    end
  end
  end
end
