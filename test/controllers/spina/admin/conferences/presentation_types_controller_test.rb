# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class PresentationTypesControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @presentation_type = spina_admin_conferences_presentation_types :oral_1
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
          attributes = @presentation_type.attributes
          attributes[:minutes] = @presentation_type.minutes
          attributes[:name] = @presentation_type.name
          assert_difference 'PresentationType.count' do
            post admin_conferences_presentation_types_url, params: { admin_conferences_presentation_type: attributes }
          end
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type saved', flash[:success]
        end

        test 'should create presentation type with remote form' do
          attributes = @presentation_type.attributes
          attributes[:minutes] = @presentation_type.minutes
          attributes[:name] = @presentation_type.name
          assert_difference 'PresentationType.count' do
            post admin_conferences_presentation_types_url, params: { admin_conferences_presentation_type: attributes }, xhr: true
          end
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type saved', flash[:success]
        end

        test 'should fail to create invalid presentation type' do
          attributes = @invalid_presentation_type.attributes
          attributes[:minutes] = @invalid_presentation_type.minutes
          attributes[:name] = @invalid_presentation_type.name
          assert_no_difference 'PresentationType.count' do
            post admin_conferences_presentation_types_url, params: { admin_conferences_presentation_type: attributes }
          end
          assert_response :success
          assert_not_equal 'Presentation type saved', flash[:success]
        end

        test 'should fail to create invalid presentation type with remote form' do
          attributes = @invalid_presentation_type.attributes
          attributes[:minutes] = @invalid_presentation_type.minutes
          attributes[:name] = @invalid_presentation_type.name
          assert_no_difference 'PresentationType.count' do
            post admin_conferences_presentation_types_url, params: { admin_conferences_presentation_type: attributes }, xhr: true
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
          assert_select('#sessions tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should update presentation type' do
          attributes = @presentation_type.attributes
          attributes[:minutes] = @presentation_type.minutes
          attributes[:name] = @presentation_type.name
          patch admin_conferences_presentation_type_url(@presentation_type), params: { admin_conferences_presentation_type: attributes }
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type saved', flash[:success]
        end

        test 'should update presentation type with remote form' do
          attributes = @presentation_type.attributes
          attributes[:minutes] = @presentation_type.minutes
          attributes[:name] = @presentation_type.name
          patch admin_conferences_presentation_type_url(@presentation_type),
                params: { admin_conferences_presentation_type: attributes }, xhr: true
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type saved', flash[:success]
        end

        test 'should fail to update invalid presentation type' do
          attributes = @invalid_presentation_type.attributes
          attributes[:minutes] = @invalid_presentation_type.minutes
          attributes[:name] = @invalid_presentation_type.name
          patch admin_conferences_presentation_type_url(@presentation_type), params: { admin_conferences_presentation_type: attributes }
          assert_response :success
          assert_not_equal 'Presentation type saved', flash[:success]
        end

        test 'should fail to update invalid presentation type with remote form' do
          attributes = @invalid_presentation_type.attributes
          attributes[:minutes] = @invalid_presentation_type.minutes
          attributes[:name] = @invalid_presentation_type.name
          patch admin_conferences_presentation_type_url(@presentation_type),
                params: { admin_conferences_presentation_type: attributes }, xhr: true
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

        test 'should destroy presentation type with remote form' do
          assert_difference 'PresentationType.count', -1 do
            delete admin_conferences_presentation_type_url(@presentation_type), xhr: true
          end
          assert_redirected_to admin_conferences_presentation_types_url
          assert_equal 'Presentation type deleted', flash[:success]
        end
      end
    end
  end
end
