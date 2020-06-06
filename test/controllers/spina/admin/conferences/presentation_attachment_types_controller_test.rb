# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class PresentationAttachmentTypesControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @presentation_attachment_type = spina_admin_conferences_presentation_attachment_types :slides
          @invalid_presentation_attachment_type = PresentationAttachmentType.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_presentation_attachment_types_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_presentation_attachment_type_url
          assert_response :success
        end

        test 'should create presentation attachment type' do
          attributes = @presentation_attachment_type.attributes
          attributes[:name] = @presentation_attachment_type.name
          assert_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url, params: { admin_conferences_presentation_attachment_type: attributes }
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should create presentation attachment type with remote form' do
          attributes = @presentation_attachment_type.attributes
          attributes[:name] = @presentation_attachment_type.name
          assert_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url,
                 params: { admin_conferences_presentation_attachment_type: attributes }, xhr: true
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to create invalid presentation attachment type' do
          attributes = @invalid_presentation_attachment_type.attributes
          attributes[:name] = @invalid_presentation_attachment_type.name
          assert_no_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url, params: { admin_conferences_presentation_attachment_type: attributes }
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to create invalid presentation attachment type with remote form' do
          attributes = @invalid_presentation_attachment_type.attributes
          attributes[:name] = @invalid_presentation_attachment_type.name
          assert_no_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url,
                 params: { admin_conferences_presentation_attachment_type: attributes }, xhr: true
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should get edit' do
          get edit_admin_conferences_presentation_attachment_type_url(@presentation_attachment_type)
          assert_response :success
        end

        test 'should update presentation attachment type' do
          attributes = @presentation_attachment_type.attributes
          attributes[:name] = @presentation_attachment_type.name
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { admin_conferences_presentation_attachment_type: attributes }
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should update presentation attachment type with remote form' do
          attributes = @presentation_attachment_type.attributes
          attributes[:name] = @presentation_attachment_type.name
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { admin_conferences_presentation_attachment_type: attributes }, xhr: true
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to update invalid presentation attachment type' do
          attributes = @invalid_presentation_attachment_type.attributes
          attributes[:name] = @invalid_presentation_attachment_type.name
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { admin_conferences_presentation_attachment_type: attributes }
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to update invalid presentation attachment type with remote form' do
          attributes = @invalid_presentation_attachment_type.attributes
          attributes[:name] = @invalid_presentation_attachment_type.name
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { admin_conferences_presentation_attachment_type: attributes }, xhr: true
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should destroy presentation attachment type' do
          assert_difference 'PresentationAttachmentType.count', -1 do
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type)
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type deleted', flash[:success]
        end

        test 'should destroy presentation attachment type with remote form' do
          assert_difference 'PresentationAttachmentType.count', -1 do
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type), xhr: true
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type deleted', flash[:success]
        end

        test 'should fail to destroy presentation attachment type if impossible' do
          PresentationAttachmentType.before_destroy { throw :abort }
          assert_no_difference 'PresentationAttachmentType.count' do
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type)
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type deleted', flash[:success]
          Rails.autoloaders.main.reload
        end

        test 'should fail to destroy presentation attachment type if impossible with remote form' do
          PresentationAttachmentType.before_destroy { throw :abort }
          assert_no_difference 'PresentationAttachmentType.count' do
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type), xhr: true
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type deleted', flash[:success]
          Rails.autoloaders.main.reload
        end
      end
    end
  end
end
