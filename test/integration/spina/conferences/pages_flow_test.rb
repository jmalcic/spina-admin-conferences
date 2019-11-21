# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PagesFlowTest < ActionDispatch::IntegrationTest
      include ::Spina::Engine.routes.url_helpers

      test 'visit homepage' do
        get spina_pages(:homepage).materialized_path
        assert_response :success
        get spina_pages(:empty_homepage).materialized_path
        assert_response :success
        I18n.locale = :en
        get spina_pages(:homepage).materialized_path
        assert_response :success
        get spina_pages(:empty_homepage).materialized_path
        assert_response :success
      end

      test 'visit information page' do
        get spina_pages(:information).materialized_path
        assert_response :success
        get spina_pages(:empty_information).materialized_path
        assert_response :success
        I18n.locale = :en
        get spina_pages(:information).materialized_path
        assert_response :success
        get spina_pages(:empty_information).materialized_path
        assert_response :success
      end

      test 'visit about page' do
        get spina_pages(:about).materialized_path
        assert_response :success
        get spina_pages(:empty_about).materialized_path
        assert_response :success
        I18n.locale = :en
        get spina_pages(:about).materialized_path
        assert_response :success
        get spina_pages(:empty_about).materialized_path
        assert_response :success
      end

      test 'visit committee page' do
        get spina_pages(:committee).materialized_path
        assert_response :success
        get spina_pages(:empty_committee).materialized_path
        assert_response :success
        I18n.locale = :en
        get spina_pages(:committee).materialized_path
        assert_response :success
        get spina_pages(:empty_committee).materialized_path
        assert_response :success
      end

      test 'visit blank page' do
        get spina_pages(:blank).materialized_path
        assert_response :success
        get spina_pages(:empty_blank).materialized_path
        assert_response :success
        I18n.locale = :en
        get spina_pages(:blank).materialized_path
        assert_response :success
        get spina_pages(:empty_blank).materialized_path
        assert_response :success
      end
    end
  end
end
