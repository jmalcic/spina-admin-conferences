require 'test_helper'

module Spina
  module Admin
    class PresentationTypesControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers
      include ::Spina::Conferences

      setup do
        @presentation_type = spina_conferences_presentation_types :plenary_1
        @user = spina_users :joe
        post admin_sessions_url, params: { email: @user.email, password: 'password' }
      end

      test 'should get index' do
        get admin_conferences_presentation_types_url
        assert_response :success
      end

      test 'should get new' do
        get new_admin_conferences_presentation_type_url
        assert_response :success
      end

      test 'should create presentation type' do
        assert_difference('PresentationType.count') do
          attributes = @presentation_type.attributes
          attributes[:room_possession_ids] = @presentation_type.room_possession_ids
          post admin_conferences_presentation_types_url, params: { presentation_type: attributes }
        end

        assert_redirected_to admin_conferences_presentation_types_url
      end

      test 'should get edit' do
        get edit_admin_conferences_presentation_type_url(@presentation_type)
        assert_response :success
      end

      test 'should update presentation type' do
        patch admin_conferences_presentation_type_url(@presentation_type), params: {
          presentation_type: @presentation_type.attributes
        }
        assert_redirected_to admin_conferences_presentation_types_url
      end

      test 'should destroy presentation type' do
        assert_difference('PresentationType.count', -1) do
          delete admin_conferences_presentation_type_url(@presentation_type)
        end

        assert_redirected_to admin_conferences_presentation_types_url
      end
    end
  end
end
