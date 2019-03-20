# frozen_string_literal: true

# This class validates the finish date of an object to make sure it occurs
# after the start date.
class FinishDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value > record.start_date

    record.errors.add(attribute, options[:message] || :before_start_date)
  end
end
