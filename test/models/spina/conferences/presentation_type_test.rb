# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PresentationTypeTest < ActiveSupport::TestCase
      setup { @presentation_type = spina_conferences_presentation_types :plenary_1 }

      test 'presentation type attributes must not be empty' do
        presentation_type = PresentationType.new
        assert presentation_type.invalid?
        assert presentation_type.errors[:name].any?
        assert presentation_type.errors[:minutes].any?
        assert presentation_type.errors[:room_uses].any?
      end

      test 'minutes must be an integer' do
        assert @presentation_type.valid?
        assert_not @presentation_type.errors[:minutes].any?
        @presentation_type.minutes = '15.minutes'
        assert @presentation_type.invalid?
        assert @presentation_type.errors[:minutes].any?
      end

      test 'minutes must be a greater than or equal to 1' do
        assert @presentation_type.valid?
        assert_not @presentation_type.errors[:minutes].any?
        @presentation_type.minutes = 0
        assert @presentation_type.invalid?
        assert @presentation_type.errors[:minutes].any?
        @presentation_type.minutes = -1
        assert @presentation_type.invalid?
        assert @presentation_type.errors[:minutes].any?
      end
    end
  end
end
