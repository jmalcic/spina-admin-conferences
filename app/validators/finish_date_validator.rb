# frozen_string_literal: true

# This class validates the finish date of an object to make sure it occurs
# after the start date.
class FinishDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :before_start_date) unless value.present? && value > record.start_date
  end
end
