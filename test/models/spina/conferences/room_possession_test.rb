# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class RoomPossessionTest < ActiveSupport::TestCase
      test 'room possession attributes must not be empty' do
        room_possession = RoomPossession.new
        assert room_possession.invalid?
        assert room_possession.errors[:room].any?
        assert room_possession.errors[:conference].any?
      end
    end
  end
end
