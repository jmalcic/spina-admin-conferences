# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class DelegateTypeTest < ActiveSupport::TestCase
      setup { @delegate = spina_conferences_delegates(:joe_bloggs) }

      test 'delegate attributes must not be empty' do
        delegate = Delegate.new
        assert delegate.invalid?
        assert delegate.errors[:first_name].any?
        assert delegate.errors[:last_name].any?
        assert delegate.errors[:conferences].any?
      end

      test 'email address must be email address' do
        assert_not @delegate.errors[:email_address].any?
        invalid_delegate = Delegate.new(first_name: @delegate.first_name, last_name: @delegate.last_name,
                                        conferences: @delegate.conferences, email_address: 'foo')
        assert invalid_delegate.invalid?
        assert invalid_delegate.errors[:email_address].any?
      end
    end
  end
end
