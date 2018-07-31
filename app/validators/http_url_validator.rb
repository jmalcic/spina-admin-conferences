class HttpUrlValidator < ActiveModel::EachValidator
  def self.compliant?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    return if value.present? && self.class.compliant?(value)
    record.errors.add(attribute, options[:message] || :invalid_http_https_url)
  end
end
