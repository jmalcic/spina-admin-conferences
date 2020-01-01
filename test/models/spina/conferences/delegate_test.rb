# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class DelegateTest < ActiveSupport::TestCase
      setup { @delegate = spina_conferences_delegates :joe_bloggs }

      test 'delegate attributes must not be empty' do
        delegate = Delegate.new
        assert delegate.invalid?
        assert delegate.errors[:first_name].any?
        assert delegate.errors[:last_name].any?
        assert delegate.errors[:conferences].any?
      end

      test 'email address must be email address' do
        assert @delegate.valid?
        assert_not @delegate.errors[:email_address].any?
        @delegate.email_address = 'foo'
        assert @delegate.invalid?
        assert @delegate.errors[:email_address].any?
      end

      test 'URL must be HTTP(S) URL' do
        assert @delegate.valid?
        assert_not @delegate.errors[:url].any?
        @delegate.url = 'ftp://www.bbc.co.uk'
        assert @delegate.invalid?
        assert @delegate.errors[:url].any?
        @delegate.url = '\\'
        assert @delegate.invalid?
        assert @delegate.errors[:url].any?
      end

      test 'returns names' do
        assert @delegate.respond_to? :full_name
        assert @delegate.full_name.class == String
        assert @delegate.respond_to? :full_name_and_institution
        assert @delegate.full_name_and_institution.class == String
        assert @delegate.respond_to? :reversed_name
        assert @delegate.reversed_name.class == String
        assert @delegate.respond_to? :reversed_name_and_institution
        assert @delegate.reversed_name_and_institution.class == String
      end
    end
  end
end
