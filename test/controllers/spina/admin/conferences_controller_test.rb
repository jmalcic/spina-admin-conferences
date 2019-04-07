# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferencesControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @conference = spina_conferences_conferences :university_of_atlantis_2017
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_conferences_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_conference_url
          assert_response :success
        end

        test 'should create conference' do
          assert_difference %w[Conference.count ConferencePagePart.count ConferencePage.count] do
            attributes = @conference.attributes
            attributes[:room_ids] = @conference.rooms.collect(&:id)
            post admin_conferences_conferences_url, params: { conference: attributes }
          end

          assert_redirected_to admin_conferences_conferences_url
        end

        test 'should get edit' do
          get edit_admin_conferences_conference_url(@conference)
          assert_response :success
        end

        test 'should update conference' do
          patch admin_conferences_conference_url(@conference), params: { conference: @conference.attributes }
          assert_redirected_to admin_conferences_conferences_url
        end

        test 'should destroy conference' do
          assert_difference %w[Conference.count ConferencePagePart.count ConferencePage.count], -1 do
            delete admin_conferences_conference_url(@conference)
          end

          assert_redirected_to admin_conferences_conferences_url
        end
      end
    end
  end
end
