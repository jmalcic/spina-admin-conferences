# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class RoomTest < ActiveSupport::TestCase
        setup do
          @room_without_dependencies = spina_admin_conferences_rooms :room_without_dependencies
          @room_with_sessions = spina_admin_conferences_rooms :room_with_sessions
          @room_with_presentations = spina_admin_conferences_rooms :room_with_presentations
          @new_room = Room.new
        end

        test 'translates building' do
          @room_without_dependencies.building = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @room_without_dependencies.building
          @room_without_dependencies.building = 'bar'
          assert_equal 'bar', @room_without_dependencies.building
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @room_without_dependencies.building
        end

        test 'translates number' do
          @room_without_dependencies.number = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @room_without_dependencies.number
          @room_without_dependencies.number = 'bar'
          assert_equal 'bar', @room_without_dependencies.number
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @room_without_dependencies.number
        end

        test 'rooms have sorted scope' do
          assert_equal Room.i18n.order(:building, :number), Room.sorted
        end

        test 'room has associated institution' do
          assert_not_nil @room_without_dependencies.institution
          assert_nil @new_room.institution
        end

        test 'room has associated sessions' do
          assert_not_empty @room_with_sessions.sessions
          assert_empty @new_room.sessions
        end

        test 'room has associated presentations' do
          assert_not_empty @room_with_presentations.presentations
          assert_empty @new_room.presentations
        end

        test 'does not destroy associated sessions' do
          assert_no_difference 'Session.count' do
            @room_with_sessions.destroy
          end
          assert_not_empty @room_with_sessions.errors[:base]
        end

        test 'institution must not be empty' do
          assert @room_without_dependencies.valid?
          assert_empty @room_without_dependencies.errors[:institution]
          @room_without_dependencies.institution = nil
          assert @room_without_dependencies.invalid?
          assert_not_empty @room_without_dependencies.errors[:institution]
        end

        test 'number must not be empty' do
          assert @room_without_dependencies.valid?
          assert_empty @room_without_dependencies.errors[:number]
          @room_without_dependencies.number = nil
          assert @room_without_dependencies.invalid?
          assert_not_empty @room_without_dependencies.errors[:number]
        end

        test 'building must not be empty' do
          assert @room_without_dependencies.valid?
          assert_empty @room_without_dependencies.errors[:building]
          @room_without_dependencies.building = nil
          assert @room_without_dependencies.invalid?
          assert_not_empty @room_without_dependencies.errors[:building]
        end

        test 'returns a name' do
          assert_not_empty @room_without_dependencies.name
          assert_nil @new_room.name
        end
      end
    end
  end
end
