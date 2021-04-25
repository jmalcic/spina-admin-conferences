# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class PresentationAttachmentTypesControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @presentation_attachment_type = spina_admin_conferences_presentation_attachment_types :slides
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

        test 'should get edit' do
          get edit_admin_conferences_presentation_attachment_type_url(@presentation_attachment_type)
          assert_response :success
        end

        test 'should get edit in locale' do
          get edit_admin_conferences_presentation_attachment_type_url(@presentation_attachment_type, locale: :en)
          assert_response :success
        end

        test 'should create presentation attachment type' do
          assert_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url, params: { presentation_attachment_type: { name: 'Slides' } }
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should create presentation attachment type with remote form' do
          assert_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url,
                 params: { presentation_attachment_type: { name: 'Slides' } }, as: :turbo_stream
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to create invalid presentation attachment type' do
          assert_no_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url, params: { presentation_attachment_type: { name: nil } }
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to create invalid presentation attachment type with remote form' do
          assert_no_difference 'PresentationAttachmentType.count' do
            post admin_conferences_presentation_attachment_types_url,
                 params: { presentation_attachment_type: { name: nil } }, as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should update presentation attachment type' do
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { presentation_attachment_type: { name: 'Slides' } }
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should update presentation attachment type with remote form' do
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { presentation_attachment_type: { name: 'Slides' } }, as: :turbo_stream
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to update invalid presentation attachment type' do
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { presentation_attachment_type: { name: nil } }
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should fail to update invalid presentation attachment type with remote form' do
          patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                params: { presentation_attachment_type: { name: nil } }, as: :turbo_stream
          assert_response :success
          assert_not_equal 'Presentation attachment type saved', flash[:success]
        end

        test 'should update presentation attachment type in locale' do
          assert_changes -> { @presentation_attachment_type.reload.name(locale: :en) }, to: 'Overhead slides' do
            patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                  params: { presentation_attachment_type: { name: 'Overhead slides' }, locale: :en }
            assert_redirected_to admin_conferences_presentation_attachment_types_url
            assert_equal 'Presentation attachment type saved', flash[:success]
          end
          assert_not_equal 'overhead slides', @presentation_attachment_type.reload.name
        end

        test 'should update presentation attachment type in locale with remote form' do
          assert_changes -> { @presentation_attachment_type.reload.name(locale: :en) }, to: 'Overhead slides' do
            patch admin_conferences_presentation_attachment_type_url(@presentation_attachment_type),
                  params: { presentation_attachment_type: { name: 'Overhead slides' }, locale: :en }, as: :turbo_stream
            assert_redirected_to admin_conferences_presentation_attachment_types_url
            assert_equal 'Presentation attachment type saved', flash[:success]
          end
          assert_not_equal 'overhead slides', @presentation_attachment_type.reload.name
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
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_presentation_attachment_types_url
          assert_equal 'Presentation attachment type deleted', flash[:success]
        end

        test 'should fail to destroy presentation attachment type if impossible' do
          callbacks = PresentationAttachmentType._destroy_callbacks
          PresentationAttachmentType.before_destroy { throw :abort }
          assert_no_difference 'PresentationAttachmentType.count' do
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type)
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type deleted', flash[:success]
          PresentationAttachmentType._destroy_callbacks = callbacks
        end

        test 'should fail to destroy presentation attachment type if impossible with remote form' do
          callbacks = PresentationAttachmentType._destroy_callbacks
          PresentationAttachmentType.before_destroy { throw :abort }
          assert_no_difference 'PresentationAttachmentType.count' do
            delete admin_conferences_presentation_attachment_type_url(@presentation_attachment_type), as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Presentation attachment type deleted', flash[:success]
          PresentationAttachmentType._destroy_callbacks = callbacks
        end
      end
    end
  end
end
