# This class validates the format of the 24-hour time of an object.
class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /([0-1][0-9]|[2][0-3]):[0-5][0-9]/
    record.errors.add(attribute, options[:message] || :invalid_time)
  end
end
