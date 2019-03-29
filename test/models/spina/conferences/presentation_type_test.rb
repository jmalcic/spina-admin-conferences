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
    end
  end
end
