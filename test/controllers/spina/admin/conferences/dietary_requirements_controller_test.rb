# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class DietaryRequirementsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @dietary_requirement = spina_admin_conferences_dietary_requirements :pescetarian
          @invalid_dietary_requirement = DietaryRequirement.new
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
          assert_select '#delegates tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.delegates.no_delegates')
          end
        end

        test 'should create dietary requirement' do
          assert_difference 'DietaryRequirement.count' do
            attributes = @dietary_requirement.attributes
            attributes[:name] = @dietary_requirement.name
            post admin_conferences_dietary_requirements_url, params: {
              admin_conferences_dietary_requirement: attributes
            }
          end
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should fail to create invalid dietary requirement' do
          assert_no_difference 'DietaryRequirement.count' do
            attributes = @invalid_dietary_requirement.attributes
            attributes[:name] = @invalid_dietary_requirement.name
            post admin_conferences_dietary_requirements_url,
                 params: { admin_conferences_dietary_requirement: attributes }
          end
          assert_response :success
          assert_not_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_dietary_requirement_url(@dietary_requirement)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 3 }
          end
        end

        test 'should update dietary requirement' do
          attributes = @dietary_requirement.attributes
          attributes[:name] = @dietary_requirement.name
          patch admin_conferences_dietary_requirement_url(@dietary_requirement), params: {
            admin_conferences_dietary_requirement: attributes
          }
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should fail to update invalid dietary requirement' do
          attributes = @invalid_dietary_requirement.attributes
          attributes[:name] = @invalid_dietary_requirement.name
          patch admin_conferences_dietary_requirement_url(@dietary_requirement),
                params: { admin_conferences_dietary_requirement: attributes }
          assert_response :success
          assert_not_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should destroy dietary requirement' do
          assert_difference 'DietaryRequirement.count', -1 do
            delete admin_conferences_dietary_requirement_url(@dietary_requirement)
          end
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement deleted', flash[:success]
        end
      end
    end
  end
end
