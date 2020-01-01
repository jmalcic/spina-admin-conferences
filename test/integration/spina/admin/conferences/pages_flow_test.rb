# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PagesFlowTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @page = spina_pages :information
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get new' do
          get new_admin_page_url
          assert_response :success
          get new_admin_page_url
          assert_response :success
        end

        test 'should create page' do
          assert_difference 'Page.count' do
            attributes = @page.attributes.reject { |key, _value| key == 'id' }
            attributes[:title] = @page.title
            post admin_pages_url, params: { page: attributes }
          end
          assert_response :redirect
        end

        test 'should get edit' do
          get edit_admin_page_url(@page)
          assert_response :success
        end

        test 'should update page' do
          patch admin_page_url(@page), params: { page: @page.attributes }
          assert_redirected_to edit_admin_page_url(@page, locale: I18n.locale)
        end

        test 'should destroy page' do
          assert_difference 'Page.count', -1 do
            delete admin_page_url(@page)
          end
          assert_redirected_to admin_pages_url
        end

        test 'should get localized new' do
          get new_admin_page_url(locale: :en)
          assert_response :success
          get new_admin_page_url(locale: :en, view_template: 'information')
          assert_response :success
        end

        test 'should get localized edit' do
          get edit_admin_page_url(@page, locale: :en)
          assert_response :success
        end

        test 'should update localized page' do
          patch admin_page_url(@page, locale: :en), params: { page: @page.attributes }
          assert_redirected_to edit_admin_page_url(@page, locale: :en)
        end
      end
    end
  end
end
