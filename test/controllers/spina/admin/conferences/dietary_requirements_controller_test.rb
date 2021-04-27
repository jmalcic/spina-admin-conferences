# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class DietaryRequirementsControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @dietary_requirement = spina_admin_conferences_dietary_requirements :pescetarian
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
            assert_select 'td', 'There are no delegates'
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_dietary_requirement_url(@dietary_requirement)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should get edit in locale' do
          get edit_admin_conferences_dietary_requirement_url(@dietary_requirement, locale: :en)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create dietary requirement' do
          assert_difference 'DietaryRequirement.count' do
            post admin_conferences_dietary_requirements_url, params: { dietary_requirement: { name: 'Carnivore' } }
          end
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement saved', flash[:success]
          assert_not_nil DietaryRequirement.i18n.find_by(name: 'Carnivore')
        end

        test 'should create dietary requirement with remote form' do
          assert_difference 'DietaryRequirement.count' do
            post admin_conferences_dietary_requirements_url, params: { dietary_requirement: { name: 'Carnivore' } }, as: :turbo_stream
          end
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement saved', flash[:success]
          assert_not_nil DietaryRequirement.i18n.find_by(name: 'Carnivore')
        end

        test 'should fail to create invalid dietary requirement' do
          assert_no_difference 'DietaryRequirement.count' do
            post admin_conferences_dietary_requirements_url, params: { dietary_requirement: { name: nil } }
          end
          assert_response :success
          assert_not_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should fail to create invalid dietary requirement with remote form' do
          assert_no_difference 'DietaryRequirement.count' do
            post admin_conferences_dietary_requirements_url, params: { dietary_requirement: { name: nil } }, as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should update dietary requirement' do
          patch admin_conferences_dietary_requirement_url(@dietary_requirement), params: { dietary_requirement: { name: 'Carnivore' } }
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement saved', flash[:success]
          assert_not_nil DietaryRequirement.i18n.find_by(id: @dietary_requirement.id, name: 'Carnivore')
        end

        test 'should update dietary requirement with remote form' do
          patch admin_conferences_dietary_requirement_url(@dietary_requirement),
                params: { dietary_requirement: { name: 'Carnivore' } }, as: :turbo_stream
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement saved', flash[:success]
          assert_not_nil DietaryRequirement.i18n.find_by(id: @dietary_requirement.id, name: 'Carnivore')
        end

        test 'should fail to update invalid dietary requirement' do
          patch admin_conferences_dietary_requirement_url(@dietary_requirement), params: { dietary_requirement: { name: nil } }
          assert_response :success
          assert_not_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should fail to update invalid dietary requirement with remote form' do
          patch admin_conferences_dietary_requirement_url(@dietary_requirement),
                params: { dietary_requirement: { name: nil } }, as: :turbo_stream
          assert_response :success
          assert_not_equal 'Dietary requirement saved', flash[:success]
        end

        test 'should update dietary requirement in locale' do
          assert_changes -> { @dietary_requirement.reload.name(locale: :en) }, to: 'Pescatarian' do
            patch admin_conferences_dietary_requirement_url(@dietary_requirement),
                  params: { dietary_requirement: { name: 'Pescatarian' }, locale: :en }
            assert_redirected_to admin_conferences_dietary_requirements_url
            assert_equal 'Dietary requirement saved', flash[:success]
          end
          assert_not_equal 'Pescatarian', @dietary_requirement.reload.name
        end

        test 'should update dietary requirement in locale with remote form' do
          assert_changes -> { @dietary_requirement.reload.name(locale: :en) }, to: 'Pescatarian' do
            patch admin_conferences_dietary_requirement_url(@dietary_requirement),
                  params: { dietary_requirement: { name: 'Pescatarian' }, locale: :en }, as: :turbo_stream
            assert_redirected_to admin_conferences_dietary_requirements_url
            assert_equal 'Dietary requirement saved', flash[:success]
          end
          assert_not_equal 'Pescatarian', @dietary_requirement.reload.name
        end

        test 'should destroy dietary requirement' do
          assert_difference 'DietaryRequirement.count', -1 do
            delete admin_conferences_dietary_requirement_url(@dietary_requirement)
          end
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement deleted', flash[:success]
        end

        test 'should destroy dietary requirement with remote form' do
          assert_difference 'DietaryRequirement.count', -1 do
            delete admin_conferences_dietary_requirement_url(@dietary_requirement), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_dietary_requirements_url
          assert_equal 'Dietary requirement deleted', flash[:success]
        end

        test 'should fail to destroy dietary requirement if impossible' do
          callbacks = DietaryRequirement._destroy_callbacks
          DietaryRequirement.before_destroy { throw :abort }
          assert_no_difference 'DietaryRequirement.count' do
            delete admin_conferences_dietary_requirement_url(@dietary_requirement)
          end
          assert_response :success
          assert_not_equal 'Dietary requirement deleted', flash[:success]
          DietaryRequirement._destroy_callbacks = callbacks
        end

        test 'should fail to destroy dietary requirement if impossible with remote form' do
          callbacks = DietaryRequirement._destroy_callbacks
          DietaryRequirement.before_destroy { throw :abort }
          assert_no_difference 'DietaryRequirement.count' do
            delete admin_conferences_dietary_requirement_url(@dietary_requirement), as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Dietary requirement deleted', flash[:success]
          DietaryRequirement._destroy_callbacks = callbacks
        end
      end
    end
  end
end
