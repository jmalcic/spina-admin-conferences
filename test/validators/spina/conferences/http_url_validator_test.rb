# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class HttpUrlValidatorTest < ActiveSupport::TestCase
      setup do
        @validator = HttpUrlValidator.new(attributes: [:content])
        @url = spina_conferences_url_parts :ruby_website
      end

      test 'valid HTTP(S) URLs are valid' do
        @url.content = 'https://www.bbc.co.uk'
        assert_nil @validator.validate_each(@url, :content, @url.content)
        @url.content = 'http://www.bbc.co.uk'
        assert_nil @validator.validate_each(@url, :content, @url.content)
      end

      test 'invalid HTTP(S) URLs are invalid' do
        @url.content = 'ftp://www.bbc.co.uk'
        assert_includes @validator.validate_each(@url, :content, @url.content),
                        'is not a valid HTTP or HTTPS URL'
      end

      test 'invalid URIs are invalid' do
        @url.content = '\\'
        assert_includes @validator.validate_each(@url, :content, @url.content),
                        'is not a valid HTTP or HTTPS URL'
      end

      test 'empty URIs are valid' do
        @url.content = nil
        assert_nil @validator.validate_each(@url, :content, @url.content)
      end
    end
  end
end
