# frozen_string_literal: true

require 'test_helper'

module Spina
  class EmailAddressPartTypeTest < ActiveSupport::TestCase
    setup { @address = spina_conferences_email_address_parts :joe_bloggs_address }

    test 'content must be email address' do
      @address.content = 'joe@bloggs.com'
      assert @address.valid?
      assert_not @address.errors[:content].any?
      @address.content = '@'
      assert @address.invalid?
      assert @address.errors[:content].any?
    end
  end
end
