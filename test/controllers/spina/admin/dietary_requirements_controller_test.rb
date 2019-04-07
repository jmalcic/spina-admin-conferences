# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class DietaryRequirementsControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @dietary_requirement = spina_conferences_dietary_requirements :pescetarian
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_dietary_requirements_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_dietary_requirement_url
          assert_response :success
        end

        test 'should create dietary requirement' do
          assert_difference('DietaryRequirement.count') do
            post admin_conferences_dietary_requirements_url, params: {
              dietary_requirement: @dietary_requirement.attributes
            }
          end

          assert_redirected_to admin_conferences_dietary_requirements_url
        end

        test 'should get edit' do
          get edit_admin_conferences_dietary_requirement_url(@dietary_requirement)
          assert_response :success
        end

        test 'should update dietary requirement' do
          patch admin_conferences_dietary_requirement_url(@dietary_requirement), params: {
            dietary_requirement: @dietary_requirement.attributes
          }
          assert_redirected_to admin_conferences_dietary_requirements_url
        end

        test 'should destroy dietary requirement' do
          assert_difference('DietaryRequirement.count', -1) do
            delete admin_conferences_dietary_requirement_url(@dietary_requirement)
          end

          assert_redirected_to admin_conferences_dietary_requirements_url
        end
      end
    end
  end
end
