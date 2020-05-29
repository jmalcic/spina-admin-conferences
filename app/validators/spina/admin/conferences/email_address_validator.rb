# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class validates the format of the email address of an object.
      class EmailAddressValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.blank?

          record.errors.add(attribute, :invalid_email_address) unless parse(value)
        end

        private

        def parse(*values)
          values.each do |value|
            address = Mail::Address.new(value)
            return address.domain.present? && address.local.present?
          end
        rescue Mail::Field::IncompleteParseError
          false
        end
      end
    end
  end
end
