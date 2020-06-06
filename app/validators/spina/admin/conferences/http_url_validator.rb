# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Validator for HTTP(S) URLs.
      class HttpUrlValidator < ActiveModel::EachValidator
        # Performs validation on the supplied record.
        # @param record [ActiveRecord::Base] the associated record
        # @param attribute [Symbol] the attribute key
        # @param value [String] the attribute value
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
    end
  end
end
