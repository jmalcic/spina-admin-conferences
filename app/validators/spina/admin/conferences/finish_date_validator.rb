# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class validates the finish date of an object to make sure it occurs
      # after the start date.
      class FinishDateValidator < ActiveModel::EachValidator
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
