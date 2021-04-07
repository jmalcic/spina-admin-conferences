# frozen_string_literal: true

require 'test_helper'

module Spina
  module Parts
    module Admin
      module Conferences
        class UrlTest < ActiveSupport::TestCase
          setup do
            @url_part = Url.new(content: 'https://www.ruby-lang.org')
            @new_url_part = Url.new
          end

          test 'URL has content' do
            assert_not_nil @url_part.content
            assert_nil @new_url_part.content
          end

          test 'URL must be HTTP(S) URL' do
            assert @url_part.valid?
            assert_empty @url_part.errors[:content]
            @url_part.content = '\\'
            assert @url_part.invalid?
            assert_not_empty @url_part.errors[:content], 'malformed URL adds error'
            @url_part.content = 'ftp://www.bbc.co.uk'
            assert @url_part.invalid?
            assert_not_empty @url_part.errors[:content], 'wrong protocol adds error'
          end
        end
      end
    end
  end
end
