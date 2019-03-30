# frozen_string_literal: true

# This class validates the format of the HTTP or HTTPS URL of an object.
class HttpUrlValidator < ActiveModel::EachValidator
  def parse(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_http_https_url) unless value.blank? || parse(value)
  end
end
