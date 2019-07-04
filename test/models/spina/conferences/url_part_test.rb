# frozen_string_literal: true

require 'test_helper'

module Spina
  class UrlPartTypeTest < ActiveSupport::TestCase
    setup { @url = spina_conferences_url_parts :ruby_website }

    test 'content must be HTTP(S) URL' do
      @url.content = 'https://www.bbc.co.uk'
      assert @url.valid?
      assert_not @url.errors[:content].any?
      @url.content = 'http://www.bbc.co.uk'
      assert @url.valid?
      assert_not @url.errors[:content].any?
      @url.content = 'ftp://www.bbc.co.uk'
      assert @url.invalid?
      assert @url.errors[:content].any?
      @url.content = '\\'
      assert @url.invalid?
      assert @url.errors[:content].any?
    end
  end
end
