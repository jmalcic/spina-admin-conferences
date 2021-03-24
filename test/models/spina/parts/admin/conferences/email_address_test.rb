# frozen_string_literal: true

require 'test_helper'

module Spina
  module Parts
    module Admin
      module Conferences
        class EmailAddressTest < ActiveSupport::TestCase
          setup do
            @email_address_part = EmailAddress.new(content: 'someone@somewhere.com')
            @new_email_address_part = EmailAddress.new
          end

          test 'email address has content' do
            assert_not_nil @email_address_part.content
            assert_nil @new_email_address_part.content
          end

          test 'email address must be email address' do
            assert @email_address_part.valid?
            assert_empty @email_address_part.errors[:content]
            @email_address_part.content = 'John Doe, Example INC <john.doe@example.com>'
            assert @email_address_part.invalid?
            assert_not_empty @email_address_part.errors[:content]
          end
        end
      end
    end
  end
end
