# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegatesControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @delegate = spina_admin_conferences_delegates :joe_bloggs
          @invalid_delegate = Delegate.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_delegates_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_delegate_url
          assert_response :success
          assert_select '#conferences tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.conferences.index.no_conferences')
          end
          assert_select '#presentations tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.presentations.index.no_presentations')
          end
        end

        test 'should create delegate' do
          attributes = @delegate.attributes
          attributes[:conference_ids] = @delegate.conference_ids
          assert_difference 'Delegate.count' do
            post admin_conferences_delegates_url, params: { admin_conferences_delegate: attributes }
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should create delegate with remote form' do
          attributes = @delegate.attributes
          attributes[:conference_ids] = @delegate.conference_ids
          assert_difference 'Delegate.count' do
            post admin_conferences_delegates_url, params: { admin_conferences_delegate: attributes }, xhr: true
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to create invalid delegate' do
          attributes = @invalid_delegate.attributes
          attributes[:conference_ids] = @invalid_delegate.conference_ids
          assert_no_difference 'Delegate.count' do
            post admin_conferences_delegates_url, params: { admin_conferences_delegate: attributes }
          end
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to create invalid delegate with remote form' do
          attributes = @invalid_delegate.attributes
          attributes[:conference_ids] = @invalid_delegate.conference_ids
          assert_no_difference 'Delegate.count' do
            post admin_conferences_delegates_url, params: { admin_conferences_delegate: attributes }, xhr: true
          end
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_delegate_url(@delegate)
          assert_response :success
          assert_select '#conferences tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 5 }
          end
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should update delegate' do
          attributes = @delegate.attributes
          attributes[:conference_ids] = @delegate.conference_ids
          patch admin_conferences_delegate_url(@delegate), params: { admin_conferences_delegate: attributes }
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should update delegate with remote form' do
          attributes = @delegate.attributes
          attributes[:conference_ids] = @delegate.conference_ids
          patch admin_conferences_delegate_url(@delegate), params: { admin_conferences_delegate: attributes },
                                                           xhr: true
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to update invalid delegate' do
          attributes = @invalid_delegate.attributes
          attributes[:conference_ids] = @invalid_delegate.conference_ids
          patch admin_conferences_delegate_url(@delegate), params: { admin_conferences_delegate: attributes }
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to update invalid delegate with remote form' do
          attributes = @invalid_delegate.attributes
          attributes[:conference_ids] = @invalid_delegate.conference_ids
          patch admin_conferences_delegate_url(@delegate), params: { admin_conferences_delegate: attributes }, xhr: true
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should destroy delegate' do
          assert_difference 'Delegate.count', -1 do
            delete admin_conferences_delegate_url(@delegate)
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate deleted', flash[:success]
        end

        test 'should destroy delegate with remote form' do
          assert_difference 'Delegate.count', -1 do
            delete admin_conferences_delegate_url(@delegate), xhr: true
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate deleted', flash[:success]
        end

        test 'should fail to destroy delegate if impossible' do
          Delegate.before_destroy { throw :abort }
          assert_no_difference 'Delegate.count' do
            delete admin_conferences_delegate_url(@delegate)
          end
          assert_response :success
          assert_not_equal 'Delegate deleted', flash[:success]
          Rails.autoloaders.main.reload
        end

        test 'should fail to destroy delegate if impossible with remote form' do
          Delegate.before_destroy { throw :abort }
          assert_no_difference 'Delegate.count' do
            delete admin_conferences_delegate_url(@delegate), xhr: true
          end
          assert_response :success
          assert_not_equal 'Delegate deleted', flash[:success]
          Rails.autoloaders.main.reload
        end

        test 'should enqueue delegate import' do
          assert_enqueued_with job: DelegateImportJob do
            post import_admin_conferences_delegates_url,
                 params: { file: fixture_file_upload(file_fixture('delegates.csv')) }
          end
        end
      end
    end
  end
end
