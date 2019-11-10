# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class RoomsTest < ApplicationSystemTestCase
        include ::Spina::Engine.routes.url_helpers

        setup do
          @room = spina_conferences_rooms :lecture_block_2
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_rooms_url
          assert_selector '.breadcrumbs', text: 'Rooms'
        end

        test 'creating a room' do
          visit admin_conferences_rooms_url
          click_on 'New room'
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          click_on 'Save room'
          assert_text 'Room saved'
        end

        test 'updating a room' do
          visit admin_conferences_rooms_url
          within "tr[data-room-id=\"#{@room.id}\"]" do
            click_on('Edit')
          end
          select @room.institution.name, from: 'room_institution_id'
          fill_in 'room_building', with: @room.building
          fill_in 'room_number', with: @room.number
          click_on 'Save room'
          assert_text 'Room saved'
        end

        test 'destroying a room' do
          visit admin_conferences_rooms_url
          within "tr[data-room-id=\"#{@room.id}\"]" do
            click_on('Edit')
          end
          click_on 'Permanently delete'
          click_on 'Yes, I\'m sure'
          assert_no_selector "tr[data-room-id=\"#{@room.id}\"]"
        end
      end
    end
  end
end
