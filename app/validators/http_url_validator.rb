# frozen_string_literal: true

# This class validates the format of the HTTP or HTTPS URL of an object.
class HttpUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, :invalid_http_https_url) unless parse(value)
  end

  private

  def parse(*values)
    values.each do |value|
      uri = URI.parse(value)
      return uri.is_a?(URI::HTTP) && uri.host.present?
    end
  rescue URI::InvalidURIError
    false
  end
end
