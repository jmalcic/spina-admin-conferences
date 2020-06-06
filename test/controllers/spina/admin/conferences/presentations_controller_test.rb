# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry
          @invalid_presentation = Presentation.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_presentations_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_presentation_url
          assert_response :success
          assert_select '#presenters tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.presenters.no_presenters')
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_presentation_url(@presentation)
          assert_response :success
          assert_select('#presenters tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create presentation' do
          attributes = @presentation.attributes
          attributes[:session_id] = @presentation.session_id
          attributes[:presenter_ids] = @presentation.presenter_ids
          attributes[:start_time] = @presentation.start_time
          attributes[:date] = @presentation.date
          attributes[:title] = @presentation.title
          attributes[:abstract] = @presentation.abstract
          assert_difference 'Presentation.count' do
            post admin_conferences_presentations_url, params: { admin_conferences_presentation: attributes }
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
        end

        test 'should create presentation with remote form' do
          attributes = @presentation.attributes
          attributes[:presenter_ids] = @presentation.presenter_ids
          attributes[:start_time] = @presentation.start_time
          attributes[:date] = @presentation.date
          attributes[:title] = @presentation.title
          attributes[:abstract] = @presentation.abstract
          assert_difference 'Presentation.count' do
            post admin_conferences_presentations_url, params: { admin_conferences_presentation: attributes }, xhr: true
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to create invalid presentation' do
          attributes = @invalid_presentation.attributes
          attributes[:presenter_ids] = @invalid_presentation.presenter_ids
          attributes[:start_time] = @invalid_presentation.start_time
          attributes[:date] = @invalid_presentation.date
          attributes[:title] = @invalid_presentation.title
          attributes[:abstract] = @invalid_presentation.abstract
          assert_no_difference 'Presentation.count' do
            post admin_conferences_presentations_url, params: { admin_conferences_presentation: attributes }
          end
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to create invalid presentation with remote form' do
          attributes = @invalid_presentation.attributes
          attributes[:presenter_ids] = @invalid_presentation.presenter_ids
          attributes[:start_time] = @invalid_presentation.start_time
          attributes[:date] = @invalid_presentation.date
          attributes[:title] = @invalid_presentation.title
          attributes[:abstract] = @invalid_presentation.abstract
          assert_no_difference 'Presentation.count' do
            post admin_conferences_presentations_url, params: { admin_conferences_presentation: attributes }, xhr: true
          end
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should update presentation' do
          attributes = @presentation.attributes
          attributes[:presenter_ids] = @presentation.presenter_ids
          attributes[:start_time] = @presentation.start_time
          attributes[:date] = @presentation.date
          attributes[:title] = @presentation.title
          attributes[:abstract] = @presentation.abstract
          patch admin_conferences_presentation_url(@presentation), params: { admin_conferences_presentation: attributes }
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
        end

        test 'should update presentation with remote form' do
          attributes = @presentation.attributes
          attributes[:presenter_ids] = @presentation.presenter_ids
          attributes[:start_time] = @presentation.start_time
          attributes[:date] = @presentation.date
          attributes[:title] = @presentation.title
          attributes[:abstract] = @presentation.abstract
          patch admin_conferences_presentation_url(@presentation), params: { admin_conferences_presentation: attributes }, xhr: true
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to update invalid presentation' do
          attributes = @invalid_presentation.attributes
          attributes[:presenter_ids] = @invalid_presentation.presenter_ids
          attributes[:start_time] = @invalid_presentation.start_time
          attributes[:date] = @invalid_presentation.date
          attributes[:title] = @invalid_presentation.title
          attributes[:abstract] = @invalid_presentation.abstract
          patch admin_conferences_presentation_url(@presentation), params: { admin_conferences_presentation: attributes }
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to update invalid presentation with remote form' do
          attributes = @invalid_presentation.attributes
          attributes[:presenter_ids] = @invalid_presentation.presenter_ids
          attributes[:start_time] = @invalid_presentation.start_time
          attributes[:date] = @invalid_presentation.date
          attributes[:title] = @invalid_presentation.title
          attributes[:abstract] = @invalid_presentation.abstract
          patch admin_conferences_presentation_url(@presentation), params: { admin_conferences_presentation: attributes }, xhr: true
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should destroy presentation' do
          assert_difference 'Presentation.count', -1 do
            delete admin_conferences_presentation_url(@presentation)
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation deleted', flash[:success]
        end

        test 'should destroy presentation with remote form' do
          assert_difference 'Presentation.count', -1 do
            delete admin_conferences_presentation_url(@presentation), xhr: true
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation deleted', flash[:success]
        end

        test 'should fail to destroy presentation if impossible' do
          Presentation.before_destroy { throw :abort }
          assert_no_difference 'Presentation.count' do
            delete admin_conferences_presentation_url(@presentation)
          end
          assert_response :success
          assert_not_equal 'Presentation deleted', flash[:success]
          Rails.autoloaders.main.reload
        end

        test 'should fail to destroy presentation if impossible with remote form' do
          Presentation.before_destroy { throw :abort }
          assert_no_difference 'Presentation.count' do
            delete admin_conferences_presentation_url(@presentation), xhr: true
          end
          assert_response :success
          assert_not_equal 'Presentation deleted', flash[:success]
          Rails.autoloaders.main.reload
        end

        test 'should enqueue presentation import' do
          assert_enqueued_with job: PresentationImportJob do
            post import_admin_conferences_presentations_url,
                 params: { file: fixture_file_upload(file_fixture('presentations.csv')) }
          end
        end

        test 'should render attachment form for new record' do
          get attach_new_admin_conferences_presentation_url, params: { index: 1, active: true }, xhr: true
          assert_response :success
        end

        test 'should render attachment form for existing record' do
          get attach_admin_conferences_presentation_url(@presentation), params: { index: 1, active: true }, xhr: true
          assert_response :success
        end
      end
    end
  end
end
