# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @institution = spina_conferences_institutions :university_of_atlantis
          @invalid_institution = Institution.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_institutions_url
          assert_response :success
          get admin_conferences_institutions_url, as: :json
          assert_response :success
          assert_equal 'application/json', @response.media_type
        end

        test 'should get new' do
          get new_admin_conferences_institution_url
          assert_response :success
          assert_select '#conferences tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.conferences.no_conferences')
          end
          assert_select '#delegates tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.delegates.no_delegates')
          end
          assert_select '#rooms tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.rooms.no_rooms')
          end
        end

        test 'should create institution' do
          assert_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: @institution.attributes }
          end
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution saved', flash[:success]
        end

        test 'should fail to create invalid institution' do
          assert_no_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: @invalid_institution.attributes }
          end
          assert_response :success
          assert_not_equal 'Institution saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_institution_url(@institution)
          assert_response :success
          assert_select('#conferences tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 5 }
          end
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 3 }
          end
          assert_select('#rooms tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should update institution' do
          patch admin_conferences_institution_url(@institution), params: { institution: @institution.attributes }
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution saved', flash[:success]
        end

        test 'should fail to update invalid institution' do
          patch admin_conferences_institution_url(@institution),
                params: { institution: @invalid_institution.attributes }
          assert_response :success
          assert_not_equal 'Institution saved', flash[:success]
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
