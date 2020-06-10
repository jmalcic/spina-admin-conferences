# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class RoomTest < ActiveSupport::TestCase
        setup do
          @room = spina_admin_conferences_rooms :lecture_block_2
          @new_room = Room.new
        end

        test 'translates building' do
          @room.building = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @room.building
          @room.building = 'bar'
          assert_equal 'bar', @room.building
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @room.building
        end

        test 'translates number' do
          @room.number = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @room.number
          @room.number = 'bar'
          assert_equal 'bar', @room.number
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @room.number
        end

        test 'rooms have sorted scope' do
          assert_equal Room.i18n.order(:building, :number), Room.sorted
        end

        test 'room has associated institution' do
          assert_not_nil @room.institution
          assert_nil @new_room.institution
        end

        test 'room has associated sessions' do
          assert_not_empty @room.sessions
          assert_empty @new_room.sessions
        end

        test 'room has associated presentations' do
          assert_not_empty @room.presentations
          assert_empty @new_room.presentations
        end

        test 'does not destroy associated sessions' do
          assert_no_difference 'Session.count' do
            @room.destroy
          end
          assert_not_empty @room.errors[:base]
        end

        test 'institution must not be empty' do
          assert @room.valid?
          assert_empty @room.errors[:institution]
          @room.institution = nil
          assert @room.invalid?
          assert_not_empty @room.errors[:institution]
        end

        test 'number must not be empty' do
          assert @room.valid?
          assert_empty @room.errors[:number]
          @room.number = nil
          assert @room.invalid?
          assert_not_empty @room.errors[:number]
        end

        test 'building must not be empty' do
          assert @room.valid?
          assert_empty @room.errors[:building]
          @room.building = nil
          assert @room.invalid?
          assert_not_empty @room.errors[:building]
        end

        test 'returns a name' do
          assert_not_empty @room.name
          assert_nil @new_room.name
        end
      end
    end
  end
end
