# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class RoomPossessionTest < ActiveSupport::TestCase
      setup { @room_possession = spina_conferences_room_possessions :lecture_block_2_uoa_2017 }

      test 'room possession attributes must not be empty' do
        room_possession = RoomPossession.new
        assert room_possession.invalid?
        assert room_possession.errors[:room].any?
        assert room_possession.errors[:conference].any?
      end

      test 'room must belong to associated conference' do
        assert @room_possession.valid?
        assert_not @room_possession.errors[:room].any?
        @room_possession.room = Room.where.not(institution: @room_possession.conference.institution).first
        assert @room_possession.invalid?
        assert @room_possession.errors[:room].any?
      end

      test 'returns a room name' do
        assert @room_possession.respond_to? :room_name
        assert @room_possession.room_name.class == String
      end
    end
  end
end
