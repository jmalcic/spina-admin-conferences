# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class RoomTest < ActiveSupport::TestCase
      setup { @room = spina_conferences_rooms :lecture_block_2 }

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
