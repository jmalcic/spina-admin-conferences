# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class DelegateTypeTest < ActiveSupport::TestCase
      setup do
        @delegate = spina_conferences_delegates(:joe_bloggs)
      end

      test 'delegate attributes must not be empty' do
        delegate = Delegate.new
        assert delegate.invalid?
        assert delegate.errors[:first_name].any?
        assert delegate.errors[:last_name].any?
        assert delegate.errors[:conferences].any?
      end
    end
  end
end
