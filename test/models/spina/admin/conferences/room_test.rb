# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class RoomTest < ActiveSupport::TestCase
        setup { @room = spina_admin_conferences_rooms :lecture_block_2 }

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

        test 'room attributes must not be empty' do
          room = Room.new
          assert room.invalid?
          assert room.errors[:number].any?
          assert room.errors[:building].any?
        end

        test 'returns a name' do
          assert_respond_to @room, :name
          assert_equal @room.name.class, String
        end
      end
    end
  end
end
