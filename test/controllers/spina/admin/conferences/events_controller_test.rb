# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class EventsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get new' do
          get new_admin_conferences_event_url, params: { index: 1, active: true }, xhr: true
          assert_response :success
        end

        test 'should get new with conference' do
          get new_admin_conferences_conference_event_url(@conference), params: { index: 1, active: true }, xhr: true
          assert_response :success
        end
      end
    end
  end
end
