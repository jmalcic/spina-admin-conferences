# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionsControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @institution = spina_conferences_institutions :university_of_atlantis
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_institutions_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_institution_url
          assert_response :success
        end

        test 'should create institution' do
          assert_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: @institution.attributes }
          end

          assert_redirected_to admin_conferences_institutions_url
        end

        test 'should get edit' do
          get edit_admin_conferences_institution_url(@institution)
          assert_response :success
        end

        test 'should update institution' do
          patch admin_conferences_institution_url(@institution), params: { institution: @institution.attributes }
          assert_redirected_to admin_conferences_institutions_url
        end

        test 'should destroy institution' do
          assert_difference 'Institution.count', -1 do
            delete admin_conferences_institution_url(@institution)
          end

          assert_redirected_to admin_conferences_institutions_url
        end

        test 'should enqueue institution import' do
          assert_enqueued_with job: InstitutionImportJob do
            post import_admin_conferences_institutions_url,
                 params: { file: fixture_file_upload(file_fixture('institutions.csv')) }
          end
        end
      end
    end
  end
end
