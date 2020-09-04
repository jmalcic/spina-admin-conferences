# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Validator for email addresses.
      class EmailAddressValidator < ActiveModel::EachValidator
        # Performs validation on the supplied record.
        # @param record [ActiveRecord::Base] the associated record
        # @param attribute [Symbol] the attribute key
        # @param value [String] the attribute value
        def validate_each(record, attribute, value)
          return if value.blank?

          record.errors.add(attribute, :invalid_email_address) unless parse(value)
        end

        private

        def parse(value)
          Mail::Address.new(value).then { |address| address.domain.present? && address.local.present? }
        rescue Mail::Field::IncompleteParseError
          false
        end
      end
    end
  end
end
