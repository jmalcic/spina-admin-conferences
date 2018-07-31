# This class validates the date of an object to make sure it occurs during
# the associated conference.
class ConferenceDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.conference.dates.include? value
    record.errors.add(attribute, options[:message] || :outside_conference)
  end
end