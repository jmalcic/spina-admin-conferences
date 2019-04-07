# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class RoomUsesControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @presentation_type = spina_conferences_presentation_types :plenary_1
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_presentation_type_room_uses_url(presentation_type_id: @presentation_type.id), as: :json
          assert_response :success
        end
      end
    end
  end
end
