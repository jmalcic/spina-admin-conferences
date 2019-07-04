# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class RoomsControllerTest < ActionDispatch::IntegrationTest
        include ::Spina::Engine.routes.url_helpers
        include ::Spina::Conferences

        setup do
          @room = spina_conferences_rooms :lecture_block_2
          @invalid_room = Room.new
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_rooms_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_room_url
          assert_response :success
        end

        test 'should create room' do
          assert_difference 'Room.count' do
            post admin_conferences_rooms_url, params: { room: @room.attributes }
          end
          assert_redirected_to admin_conferences_rooms_url
        end

        test 'should fail to create invalid room' do
          assert_no_difference 'Room.count' do
            post admin_conferences_rooms_url, params: { room: @invalid_room.attributes }
          end
          assert_response :success
        end

        test 'should get edit' do
          get edit_admin_conferences_room_url(@room)
          assert_response :success
        end

        test 'should update room' do
          patch admin_conferences_room_url(@room), params: { room: @room.attributes }
          assert_redirected_to admin_conferences_rooms_url
        end

        test 'should fail to update invalid room' do
          patch admin_conferences_room_url(@room), params: { room: @invalid_room.attributes }
          assert_response :success
        end

        test 'should destroy room' do
          assert_difference 'Room.count', -1 do
            delete admin_conferences_room_url(@room)
          end
          assert_redirected_to admin_conferences_rooms_url
        end

        test 'should enqueue room import' do
          assert_enqueued_with job: RoomImportJob do
            post import_admin_conferences_rooms_url,
                 params: { file: fixture_file_upload(file_fixture('rooms.csv')) }
          end
        end
      end
    end
  end
end
