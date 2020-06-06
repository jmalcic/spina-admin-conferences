# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferencesControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017
          @invalid_conference = Conference.new
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
          assert_select '#delegates tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.delegates.index.no_delegates')
          end
          assert_select '#presentation_types tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.presentation_types.index.no_presentation_types')
          end
          assert_select '#presentations tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.presentations.index.no_presentations')
          end
          assert_select '#rooms tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.rooms.index.no_rooms')
          end
        end

        test 'should create conference' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should create conference with remote form' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }, xhr: true
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to create invalid conference' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          assert_no_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to create invalid conference with remote form' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          assert_no_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes}, xhr: true
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_conference_url(@conference)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select '#presentation_types tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select('#rooms tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should update conference' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should update conference with remote form' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, xhr: true
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference with remote form' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, xhr: true
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should destroy conference' do
          assert_difference 'Conference.count', -1 do
            delete admin_conferences_conference_url(@conference)
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference deleted', flash[:success]
        end

        test 'should destroy conference with remote form' do
          assert_difference 'Conference.count', -1 do
            delete admin_conferences_conference_url(@conference), xhr: true
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference deleted', flash[:success]
        end
      end
    end
  end
end
