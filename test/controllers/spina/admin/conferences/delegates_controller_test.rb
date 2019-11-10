# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegatesControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @delegate = spina_conferences_delegates :joe_bloggs
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
            assert_select 'td', I18n.t('spina.conferences.conferences.no_conferences')
          end
          assert_select '#presentations tbody > tr' do
            assert_select 'td', I18n.t('spina.conferences.presentations.no_presentations')
          end
        end

        test 'should create delegate' do
          assert_difference 'Delegate.count' do
            attributes = @delegate.attributes
            attributes[:conference_ids] = @delegate.conferences.collect(&:id)
            post admin_conferences_delegates_url, params: { delegate: attributes }
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to create invalid delegate' do
          assert_no_difference 'Delegate.count' do
            post admin_conferences_delegates_url, params: { delegate: @invalid_delegate.attributes }
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
          patch admin_conferences_delegate_url(@delegate), params: { delegate: @delegate.attributes }
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to update invalid delegate' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @invalid_delegate.attributes }
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should destroy delegate' do
          assert_difference 'Delegate.count', -1 do
            delete admin_conferences_delegate_url(@delegate)
          end
          assert_redirected_to admin_conferences_delegates_url
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
