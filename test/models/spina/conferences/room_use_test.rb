# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class RoomUseTest < ActiveSupport::TestCase
      test 'room use attributes must not be empty' do
        room_use = RoomUse.new
        assert room_use.invalid?
        assert room_use.errors[:room_possession].any?
        assert room_use.errors[:presentation_type].any?
      end
    end
  end
end
