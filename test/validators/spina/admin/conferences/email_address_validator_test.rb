# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class EmailAddressValidatorTest < ActiveSupport::TestCase
        setup do
          @validator = EmailAddressValidator.new(attributes: [:email_address])
          @delegate = spina_admin_conferences_delegates(:joe_bloggs)
        end

        test 'valid email addresses are valid' do
          @delegate.email_address = 'foo@bar.com'
          @validator.validate_each(@delegate, :email_address, @delegate.email_address)
          assert_empty @delegate.errors[:email_address]
        end

        test 'email addresses without domains and local parts are invalid' do
          @delegate.email_address = 'foo@'
          @validator.validate_each(@delegate, :email_address, @delegate.email_address)
          assert_includes @delegate.errors[:email_address], 'is not an email address'
          @delegate.email_address = '@bar.com'
          @validator.validate_each(@delegate, :email_address, @delegate.email_address)
          assert_includes @delegate.errors[:email_address], 'is not an email address'
        end

        test 'invalid email addresses are invalid' do
          @delegate.email_address = 'John Doe, Example INC <john.doe@example.com>'
          @validator.validate_each(@delegate, :email_address, @delegate.email_address)
          assert_includes @delegate.errors[:email_address], 'is not an email address'
        end

        test 'empty email addresses are valid' do
          @delegate.email_address = nil
          @validator.validate_each(@delegate, :email_address, @delegate.email_address)
          assert_empty @delegate.errors[:email_address]
        end
      end
    end
  end
end
