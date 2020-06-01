# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class SessionsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @session = spina_admin_conferences_sessions :oral_1_lecture_block_2_uoa_2017
          @invalid_session = Session.new
          @empty_session = spina_admin_conferences_sessions :empty_session
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_sessions_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_session_url
          assert_response :success
          assert_select '#presentations tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.presentations.no_presentations')
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_session_url(@session)
          assert_response :success
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create session' do
          assert_difference 'Session.count' do
            attributes = @session.attributes
            attributes[:name] = @session.name
            post admin_conferences_sessions_url, params: { admin_conferences_session: attributes }
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
        end

        test 'should create session with remote form' do
          assert_difference 'Session.count' do
            attributes = @session.attributes
            attributes[:name] = @session.name
            post admin_conferences_sessions_url, params: { admin_conferences_session: attributes }, xhr: true
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
        end

        test 'should fail to create invalid session' do
          assert_no_difference 'Session.count' do
            attributes = @invalid_session.attributes
            attributes[:name] = @invalid_session.name
            post admin_conferences_sessions_url, params: { admin_conferences_session: attributes }
          end
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should fail to create invalid session with remote form' do
          assert_no_difference 'Session.count' do
            attributes = @invalid_session.attributes
            attributes[:name] = @invalid_session.name
            post admin_conferences_sessions_url, params: { admin_conferences_session: attributes }, xhr: true
          end
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should update session' do
          attributes = @session.attributes
          attributes[:name] = @session.name
          patch admin_conferences_session_url(@session), params: { admin_conferences_session: attributes }
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
        end

        test 'should update session with remote form' do
          attributes = @session.attributes
          attributes[:name] = @session.name
          patch admin_conferences_session_url(@session), params: { admin_conferences_session: attributes }, xhr: true
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
        end

        test 'should fail to update invalid session' do
          attributes = @invalid_session.attributes
          attributes[:name] = @invalid_session.name
          patch admin_conferences_session_url(@session), params: { admin_conferences_session: attributes }
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should fail to update invalid session with remote form' do
          attributes = @invalid_session.attributes
          attributes[:name] = @invalid_session.name
          patch admin_conferences_session_url(@session), params: { admin_conferences_session: attributes }, xhr: true
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should destroy session' do
          assert_difference 'Session.count', -1 do
            delete admin_conferences_session_url(@empty_session)
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session deleted', flash[:success]
        end

        test 'should destroy session with remote form' do
          assert_difference 'Session.count', -1 do
            delete admin_conferences_session_url(@empty_session), xhr: true
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session deleted', flash[:success]
        end

        test 'should fail to destroy session with dependent records' do
          assert_no_difference 'Session.count' do
            delete admin_conferences_session_url(@session)
          end
          assert_response :success
          assert_not_equal 'Session deleted', flash[:success]
        end

        test 'should fail to destroy session with dependent records with remote form' do
          assert_no_difference 'Session.count' do
            delete admin_conferences_session_url(@session), xhr: true
          end
          assert_response :success
          assert_not_equal 'Session deleted', flash[:success]
        end
      end
    end
  end
end
