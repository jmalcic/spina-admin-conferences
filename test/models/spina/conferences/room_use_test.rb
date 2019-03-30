# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class RoomUseTest < ActiveSupport::TestCase
      setup { @room_use = spina_conferences_room_uses :plenary_1_lecture_block_3_uoa_2017 }

      test 'room use attributes must not be empty' do
        room_use = RoomUse.new
        assert room_use.invalid?
        assert room_use.errors[:room_possession].any?
        assert room_use.errors[:presentation_type].any?
      end

      test 'room possession must belong to associated conference' do
        assert @room_use.valid?
        assert_not @room_use.errors[:room_possession].any?
        @room_use.room_possession = RoomPossession.where.not(conference: @room_use.conference).first
        assert @room_use.invalid?
        assert @room_use.errors[:room_possession].any?
      end

      test 'returns a room name' do
        assert @room_use.respond_to? :room_name
        assert @room_use.room_name.class == String
      end
    end
  end
end
