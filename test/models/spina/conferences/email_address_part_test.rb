# frozen_string_literal: true

require 'test_helper'

module Spina
  class EmailAddressPartTypeTest < ActiveSupport::TestCase
    setup { @email_address_part = spina_conferences_email_address_parts :valid_address }

    test 'content must be email address' do
      assert @email_address_part.valid?
      assert_not @email_address_part.errors[:content].any?
      @email_address_part.content = 'invalid'
      assert @email_address_part.invalid?
      assert @email_address_part.errors[:content].any?
      @email_address_part.content = '@'
      assert @email_address_part.invalid?
      assert @email_address_part.errors[:content].any?
      @email_address_part.content = '.'
      assert @email_address_part.invalid?
      assert @email_address_part.errors[:content].any?
      @email_address_part.content = '@.'
      assert @email_address_part.invalid?
      assert @email_address_part.errors[:content].any?
      @email_address_part.content = '#'
      assert @email_address_part.invalid?
      assert @email_address_part.errors[:content].any?
    end
  end
end
