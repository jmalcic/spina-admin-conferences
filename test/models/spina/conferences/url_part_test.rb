# frozen_string_literal: true

require 'test_helper'

module Spina
  class UrlPartTypeTest < ActiveSupport::TestCase
    setup { @url_part = spina_conferences_url_parts :valid_url }

    test 'content must be http(s) URL' do
      assert @url_part.valid?
      assert_not @url_part.errors[:content].any?
      @url_part.content = 'invalid'
      assert @url_part.invalid?
      assert @url_part.errors[:content].any?
      @url_part.content = 'http://'
      assert @url_part.invalid?
      assert @url_part.errors[:content].any?
      @url_part.content = '.'
      assert @url_part.invalid?
      assert @url_part.errors[:content].any?
      @url_part.content = '/'
      assert @url_part.invalid?
      assert @url_part.errors[:content].any?
    end
  end
end
