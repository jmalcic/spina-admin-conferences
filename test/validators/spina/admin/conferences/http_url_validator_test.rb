# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class HttpUrlValidatorTest < ActiveSupport::TestCase
        setup do
          @validator = HttpUrlValidator.new(attributes: [:url])
          @delegate = spina_admin_conferences_delegates(:joe_bloggs)
        end

        test 'valid HTTP(S) URLs are valid' do
          @delegate.url = 'https://www.bbc.co.uk'
          @validator.validate_each(@delegate, :url, @delegate.url)
          assert_empty @delegate.errors[:url]
          @delegate.url = 'http://www.bbc.co.uk'
          @validator.validate_each(@delegate, :url, @delegate.url)
          assert_empty @delegate.errors[:url]
        end

        test 'invalid HTTP(S) URLs are invalid' do
          @delegate.url = 'ftp://www.bbc.co.uk'
          @validator.validate_each(@delegate, :url, @delegate.url)
          assert_includes @delegate.errors[:url], 'is not a valid HTTP or HTTPS URL'
        end

        test 'invalid URIs are invalid' do
          @delegate.url = '\\'
          @validator.validate_each(@delegate, :url, @delegate.url)
          assert_includes @delegate.errors[:url], 'is not a valid HTTP or HTTPS URL'
        end

        test 'empty URIs are valid' do
          @delegate.url = nil
          @validator.validate_each(@delegate, :url, @delegate.url)
          assert_empty @delegate.errors[:url]
        end
      end
    end
  end
end
