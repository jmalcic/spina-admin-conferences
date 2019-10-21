# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PagesFlowTest < ActionDispatch::IntegrationTest
      include ::Spina::Engine.routes.url_helpers

      test 'can visit pages' do
        get spina_pages(:homepage_page).materialized_path
        assert_response :success
        get spina_pages(:information_page).materialized_path
        assert_response :success
        get spina_pages(:about_page).materialized_path
        assert_response :success
        get spina_pages(:blank_page).materialized_path
        assert_response :success
      end

      test 'can visit pages in locale' do
        I18n.locale = :en
        get spina_pages(:homepage_page).materialized_path
        assert_response :success
        get spina_pages(:information_page).materialized_path
        assert_response :success
        get spina_pages(:about_page).materialized_path
        assert_response :success
        get spina_pages(:blank_page).materialized_path
        assert_response :success
      end
    end
  end
end
