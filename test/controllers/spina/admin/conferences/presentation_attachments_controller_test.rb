# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      # noinspection RubyClassModuleNamingConvention
      class PresentationAttachmentsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers

        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get new' do
          get new_admin_conferences_presentation_attachment_url, params: { index: 1, active: true }, xhr: true
          assert_response :success
        end

        test 'should get new with presentation' do
          get new_admin_conferences_presentation_presentation_attachment_url(@presentation), params: { index: 1, active: true }, xhr: true
          assert_response :success
        end
      end
    end
  end
end
