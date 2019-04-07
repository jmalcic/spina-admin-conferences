# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationsControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @presentation = spina_conferences_presentations :asymmetry_and_antisymmetry
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_presentations_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_presentation_url
          assert_response :success
        end

        test 'should create presentation' do
          assert_difference(%w[Presentation.count ConferencePagePart.count ConferencePage.count]) do
            attributes = @presentation.attributes
            attributes[:presenter_ids] = @presentation.presenters.collect(&:id)
            post admin_conferences_presentations_url, params: { presentation: attributes }
          end

          assert_redirected_to admin_conferences_presentations_url
        end

        test 'should get edit' do
          get edit_admin_conferences_presentation_url(@presentation)
          assert_response :success
        end

        test 'should update presentation' do
          patch admin_conferences_presentation_url(@presentation), params: { presentation: @presentation.attributes }
          assert_redirected_to admin_conferences_presentations_url
        end

        test 'should destroy presentation' do
          assert_difference(%w[Presentation.count ConferencePagePart.count ConferencePage.count], -1) do
            delete admin_conferences_presentation_url(@presentation)
          end

          assert_redirected_to admin_conferences_presentations_url
        end

        test 'should enqueue presentation import' do
          assert_enqueued_with job: PresentationImportJob do
            post import_admin_conferences_presentations_url,
                 params: { file: fixture_file_upload(file_fixture('presentations.csv')) }
          end
        end
      end
    end
  end
end
