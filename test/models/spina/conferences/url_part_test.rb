# frozen_string_literal: true

require 'test_helper'

module Spina
  class UrlPartTest < ActiveSupport::TestCase
    setup { @url_part = spina_conferences_url_parts :ruby_website }

    test 'content must be HTTP(S) URL' do
      @url_part.content = 'https://www.bbc.co.uk'
      assert @url_part.valid?
      assert_not @url_part.errors[:content].any?
      @url_part.content = 'http://www.bbc.co.uk'
      assert @url_part.valid?
      assert_not @url_part.errors[:content].any?
      @url_part.content = 'ftp://www.bbc.co.uk'
      assert @url_part.invalid?
      assert @url_part.errors[:content].any?
      @url_part.content = '\\'
      assert @url_part.invalid?
      assert @url_part.errors[:content].any?
    end
  end
end
