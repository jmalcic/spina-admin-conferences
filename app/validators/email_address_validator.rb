# frozen_string_literal: true

# This class validates the format of the email address of an object.
class EmailAddressValidator < ActiveModel::EachValidator
  def parse(value)
    address = Mail::Address.new(value)
    address.domain.present? && address.local.present?
  rescue Mail::Field::IncompleteParseError
    false
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_email_address) unless value.blank? || parse(value)
  end
end
