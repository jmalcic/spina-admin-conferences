# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegatesControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
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
            assert_select 'td', 'There are no conferences'
          end
          assert_select '#presentations tbody > tr' do
            assert_select 'td', 'There are no presentations'
          end
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

        test 'should get edit in locale' do
          get edit_admin_conferences_delegate_url(@delegate, locale: :en)
          assert_response :success
          assert_select '#conferences tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 5 }
          end
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create delegate' do
          assert_difference 'Delegate.count' do
            post admin_conferences_delegates_url, params: { delegate: @delegate.attributes.merge(conference_ids: @delegate.conference_ids) }
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should create delegate with remote form' do
          assert_difference 'Delegate.count' do
            post admin_conferences_delegates_url,
                 params: { delegate: @delegate.attributes.merge(conference_ids: @delegate.conference_ids) }, as: :turbo_stream
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to create invalid delegate' do
          assert_no_difference 'Delegate.count' do
            post admin_conferences_delegates_url,
                 params: { delegate: @invalid_delegate.attributes.merge(conference_ids: @invalid_delegate.conference_ids) }
          end
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to create invalid delegate with remote form' do
          assert_no_difference 'Delegate.count' do
            post admin_conferences_delegates_url,
                 params: { delegate: @invalid_delegate.attributes.merge(conference_ids: @invalid_delegate.conference_ids) },
                 as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should update delegate' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @delegate.attributes.merge(conference_ids: @delegate.conference_ids) }
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should update delegate with remote form' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @delegate.attributes.merge(conference_ids: @delegate.conference_ids) }, as: :turbo_stream
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to update invalid delegate' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @invalid_delegate.attributes.merge(conference_ids: @invalid_delegate.conference_ids) }
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should fail to update invalid delegate with remote form' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @invalid_delegate.attributes.merge(conference_ids: @invalid_delegate.conference_ids) },
                as: :turbo_stream
          assert_response :success
          assert_not_equal 'Delegate saved', flash[:success]
        end

        test 'should update delegate in locale' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @delegate.attributes.merge(conference_ids: @delegate.conference_ids), locale: :en }
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
        end

        test 'should update delegate in locale with remote form' do
          patch admin_conferences_delegate_url(@delegate),
                params: { delegate: @delegate.attributes.merge(conference_ids: @delegate.conference_ids), locale: :en }, as: :turbo_stream
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate saved', flash[:success]
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
            delete admin_conferences_delegate_url(@delegate), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_delegates_url
          assert_equal 'Delegate deleted', flash[:success]
        end

        test 'should fail to destroy delegate if impossible' do
          callbacks = Delegate._destroy_callbacks
          Delegate.before_destroy { throw :abort }
          assert_no_difference 'Delegate.count' do
            delete admin_conferences_delegate_url(@delegate)
          end
          assert_response :success
          assert_not_equal 'Delegate deleted', flash[:success]
          Delegate._destroy_callbacks = callbacks
        end

        test 'should fail to destroy delegate if impossible with remote form' do
          callbacks = Delegate._destroy_callbacks
          Delegate.before_destroy { throw :abort }
          assert_no_difference 'Delegate.count' do
            delete admin_conferences_delegate_url(@delegate), as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Delegate deleted', flash[:success]
          Delegate._destroy_callbacks = callbacks
        end

        test 'should enqueue delegate import' do
          file_fixture('delegates.csv.erb').read
            .then { |file| ERB.new(file).result(binding) }
            .then { |result| Pathname.new(File.join(file_fixture_path, 'delegates.csv')).write(result) }
          assert_enqueued_with job: DelegateImportJob do
            post import_admin_conferences_delegates_url,
                 params: { file: fixture_file_upload(file_fixture('delegates.csv')) }
          end
        end
      end
    end
  end
end
