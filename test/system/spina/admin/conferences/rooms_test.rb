# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class RoomsTest < ApplicationSystemTestCase
        setup do
          @room = spina_admin_conferences_rooms :lecture_block_2
          @empty_room = spina_admin_conferences_rooms :empty_room
        end

        test 'visiting the index' do
          visit admin_conferences_rooms_path
          Percy.snapshot page, name: 'Rooms index'
        end

        test 'creating a room' do
          visit admin_conferences_rooms_path
          click_on 'New room'
          assert_current_path new_admin_conferences_room_path
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          Percy.snapshot page, name: 'Rooms form on create'
          click_on 'Save room'
          assert_current_path admin_conferences_rooms_path
          assert_text 'Room saved'
          Percy.snapshot page, name: 'Rooms index on create'
        end

        test 'updating a room' do
          visit admin_conferences_rooms_path
          within "tr[data-room-id=\"#{@room.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_room_path(@room)
          Percy.snapshot page, name: 'Rooms form on update'
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          click_on 'Save room'
          assert_current_path admin_conferences_rooms_path
          assert_text 'Room saved'
          Percy.snapshot page, name: 'Rooms index on update'
        end

        test 'updating a room in a locale' do
          visit admin_conferences_rooms_path
          within "tr[data-room-id=\"#{@room.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_room_path(@room)
          click_link 'British English'
          click_link 'English'
          assert_current_path edit_admin_conferences_room_path(@room, locale: :en)
          Percy.snapshot page, name: 'Rooms form on update in locale'
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          click_on 'Save room'
          assert_current_path admin_conferences_rooms_path
          assert_text 'Room saved'
          Percy.snapshot page, name: 'Rooms index on update in locale'
        end

        test 'destroying a room' do
          visit admin_conferences_rooms_path
          within "tr[data-room-id=\"#{@empty_room.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_room_path(@empty_room)
          accept_confirm "Are you sure you want to delete the room <strong>#{@empty_room.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Rooms delete dialog'
          end
          assert_current_path admin_conferences_rooms_path
          assert_text 'Room deleted'
          assert_no_selector "tr[data-room-id=\"#{@empty_room.id}\"]"
          Percy.snapshot page, name: 'Rooms index on delete'
        end
      end
    end
  end
end
