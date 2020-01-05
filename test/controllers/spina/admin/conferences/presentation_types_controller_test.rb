# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class PresentationTypesControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @presentation_type = spina_conferences_presentation_types :oral_1
          @invalid_presentation_type = PresentationType.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_presentation_types_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_presentation_type_url
          assert_response :success
        end

        test 'should create presentation type' do
          assert_difference 'PresentationType.count' do
            attributes = @presentation_type.attributes
            attributes[:room_possession_ids] = @presentation_type.room_possession_ids
            post admin_conferences_presentation_types_url, params: { presentation_type: attributes }
          end
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type saved', flash[:success]
        end

        test 'should fail to create invalid presentation type' do
          assert_no_difference 'PresentationType.count' do
            post admin_conferences_presentation_types_url,
                 params: { presentation_type: @invalid_presentation_type.attributes }
          end
          assert_response :success
          assert_not_equal 'Presentation type saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_presentation_type_url(@presentation_type)
          assert_response :success
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select('#rooms tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should update presentation type' do
          patch admin_conferences_presentation_type_url(@presentation_type), params: {
            presentation_type: @presentation_type.attributes
          }
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type saved', flash[:success]
        end

        test 'should fail to update invalid presentation type' do
          patch admin_conferences_presentation_type_url(@presentation_type),
                params: { presentation_type: @invalid_presentation_type.attributes }
          assert_response :success
          assert_not_equal 'Presentation type saved', flash[:success]
        end

        test 'should destroy presentation type' do
          assert_difference 'PresentationType.count', -1 do
            delete admin_conferences_presentation_type_url(@presentation_type)
          end
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type deleted', flash[:success]
        end

        test 'should enqueue presentation type import' do
          assert_enqueued_with job: PresentationTypeImportJob do
            post import_admin_conferences_presentation_types_url,
                 params: { file: fixture_file_upload(file_fixture('presentation_types.csv')) }
          end
        end
      end
    end
  end
end
