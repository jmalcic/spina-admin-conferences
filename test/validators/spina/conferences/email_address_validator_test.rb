# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class EmailAddressValidatorTest < ActiveSupport::TestCase
      setup do
        @validator = EmailAddressValidator.new(attributes: [:content])
        @address = spina_conferences_email_address_parts :joe_bloggs_address
      end

      test 'valid email addresses are valid' do
        @address.content = 'foo@bar.com'
        assert_nil @validator.validate_each(@address, :content, @address.content)
      end

      test 'email addresses without domains and local parts are invalid' do
        @address.content = 'foo@'
        assert_includes @validator.validate_each(@address, :content, @address.content),
                        'is not an email address'
        @address.content = '@bar.com'
        assert_includes @validator.validate_each(@address, :content, @address.content),
                        'is not an email address'
      end

      test 'invalid email addresses are invalid' do
        @address.content = '#'
        assert_includes @validator.validate_each(@address, :content, @address.content),
                        'is not an email address'
      end

      test 'empty email addresses are valid' do
        @address.content = nil
        assert_nil @validator.validate_each(@address, :content, @address.content)
      end
    end
  end
end
