# frozen_string_literal: true

# This class validates the date of an object to make sure it is a valid Date.
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return Date.parse(value) if value.instance_of?(String)
    return if value.instance_of?(Date)

    record.errors.add(attribute, options[:message] || :invalid_date)
  end
end
