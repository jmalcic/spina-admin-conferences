# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class ConferencesControllerTest < ActionDispatch::IntegrationTest
      include ::Spina::Engine.routes.url_helpers

      setup do
        @conference = spina_conferences_conferences :university_of_atlantis_2017
      end

      test 'should get index' do
        get conferences_conferences_url(format: :ics)
        assert_response :success
      end

      test 'should show conference' do
        get conferences_conference_url(@conference, format: :ics)
        assert_response :success
      end
    end
  end
end
