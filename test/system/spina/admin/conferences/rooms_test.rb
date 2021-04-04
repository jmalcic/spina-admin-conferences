# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class RoomsTest < ApplicationSystemTestCase
        setup do
          @room = spina_admin_conferences_rooms :lecture_block_2
          @empty_room = spina_admin_conferences_rooms :empty_room
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_rooms_path
          assert_selector '.breadcrumbs' do
            assert_text 'Rooms'
          end
          Percy.snapshot page, name: 'Rooms index'
        end

        test 'creating a room' do
          visit admin_conferences_rooms_path
          click_on 'New room'
          assert_selector '.breadcrumbs' do
            assert_text 'New room'
          end
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          Percy.snapshot page, name: 'Rooms form on create'
          click_on 'Save room'
          assert_text 'Room saved'
          Percy.snapshot page, name: 'Rooms index on create'
        end

        test 'updating a room' do
          visit admin_conferences_rooms_path
          within "tr[data-room-id=\"#{@room.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @room.name
          end
          Percy.snapshot page, name: 'Rooms form on update'
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          click_on 'Save room'
          assert_text 'Room saved'
          Percy.snapshot page, name: 'Rooms index on update'
        end

        test 'destroying a room' do
          visit admin_conferences_rooms_path
          within "tr[data-room-id=\"#{@empty_room.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @empty_room.name
          end
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the room #{@empty_room.name}?"
          Percy.snapshot page, name: 'Rooms delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Room deleted'
          assert_no_selector "tr[data-room-id=\"#{@empty_room.id}\"]"
          Percy.snapshot page, name: 'Rooms index on delete'
        end
      end
    end
  end
end
