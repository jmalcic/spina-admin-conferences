# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class UrlPartTest < ActiveSupport::TestCase
        setup do
          @url_part = spina_admin_conferences_url_parts :valid_url
          @new_url_part = UrlPart.new
        end

        test 'url part has associated page parts' do
          assert_not_empty @url_part.page_parts
          assert_empty @new_url_part.page_parts
        end

        test 'url part has associated parts' do
          assert_not_empty @url_part.parts
          assert_empty @new_url_part.parts
        end

        test 'url part has associated layout parts' do
          assert_not_empty @url_part.layout_parts
          assert_empty @new_url_part.layout_parts
        end

        test 'url part has associated structure parts' do
          assert_not_empty @url_part.structure_parts
          assert_empty @new_url_part.structure_parts
        end

        test 'URL must be HTTP(S) URL' do
          assert @url_part.valid?
          assert_empty @url_part.errors[:content]
          @url_part.content = 'ftp://www.bbc.co.uk'
          assert @url_part.invalid?
          assert_not_empty @url_part.errors[:content], 'wrong protocol adds error'
          @url_part.restore_attributes
          @url_part.content = '\\'
          assert @url_part.invalid?
          assert_not_empty @url_part.errors[:content], 'malformed URL adds error'
        end
      end
    end
  end
end
