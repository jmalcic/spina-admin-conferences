# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class HttpUrlValidatorTest < ActiveSupport::TestCase
      setup do
        @validator = HttpUrlValidator.new(attributes: [:url])
        @delegate = spina_conferences_delegates(:joe_bloggs)
      end

      test 'valid HTTP(S) URLs are valid' do
        @delegate.url = 'https://www.bbc.co.uk'
        assert_nil @validator.validate_each(@delegate, :url, @delegate.url)
        @delegate.url = 'http://www.bbc.co.uk'
        assert_nil @validator.validate_each(@delegate, :url, @delegate.url)
      end

      test 'invalid HTTP(S) URLs are invalid' do
        @delegate.url = 'ftp://www.bbc.co.uk'
        assert_includes @validator.validate_each(@delegate, :url, @delegate.url),
                        'is not a valid HTTP or HTTPS URL'
      end

      test 'invalid URIs are invalid' do
        @delegate.url = '\\'
        assert_includes @validator.validate_each(@delegate, :url, @delegate.url),
                        'is not a valid HTTP or HTTPS URL'
      end

      test 'empty URIs are valid' do
        @delegate.url = nil
        assert_nil @validator.validate_each(@delegate, :url, @delegate.url)
      end
    end
  end
end
