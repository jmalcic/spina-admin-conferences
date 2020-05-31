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
            assert_select 'td', I18n.t('spina.conferences.presenters.no_presenters')
          end
        end

        test 'should create presentation' do
          assert_difference 'Presentation.count' do
            attributes = @presentation.attributes
            attributes[:presenter_ids] = @presentation.presenters.collect(&:id)
            attributes[:title] = @presentation.title
            attributes[:abstract] = @presentation.abstract
            post admin_conferences_presentations_url, params: { admin_conferences_presentation: attributes }
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to create invalid presentation' do
          assert_no_difference 'Presentation.count' do
            attributes = @invalid_presentation.attributes
            attributes[:presenter_ids] = @invalid_presentation.presenters.collect(&:id)
            attributes[:title] = @invalid_presentation.title
            attributes[:abstract] = @invalid_presentation.abstract
            post admin_conferences_presentations_url, params: { admin_conferences_presentation: attributes }
          end
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_presentation_url(@presentation)
          assert_response :success
          assert_select('#presenters tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 3 }
          end
        end

        test 'should update presentation' do
          attributes = @presentation.attributes
          attributes[:presenter_ids] = @presentation.presenters.collect(&:id)
          attributes[:title] = @presentation.title
          attributes[:abstract] = @presentation.abstract
          patch admin_conferences_presentation_url(@presentation), params: { admin_conferences_presentation: attributes }
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to update invalid presentation' do
          attributes = @invalid_presentation.attributes
          attributes[:presenter_ids] = @invalid_presentation.presenters.collect(&:id)
          attributes[:title] = @invalid_presentation.title
          attributes[:abstract] = @invalid_presentation.abstract
          patch admin_conferences_presentation_url(@presentation),
                params: { admin_conferences_presentation: attributes }
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

        test 'should enqueue presentation import' do
          assert_enqueued_with job: PresentationImportJob do
            post import_admin_conferences_presentations_url,
                 params: { file: fixture_file_upload(file_fixture('presentations.csv')) }
          end
        end
      end
    end
  end
end
