# frozen_string_literal: true

require 'test_helper'

module Spina
  class EmailAddressPartTest < ActiveSupport::TestCase
    setup { @email_address_part = spina_conferences_email_address_parts :joe_bloggs_address }

    test 'content must be email address' do
      @email_address_part.content = 'joe@bloggs.com'
      assert @email_address_part.valid?
      assert_not @email_address_part.errors[:content].any?
      @email_address_part.content = '@'
      assert @email_address_part.invalid?
      assert @email_address_part.errors[:content].any?
    end
  end
end
