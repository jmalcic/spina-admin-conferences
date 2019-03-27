# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PresentationTest < ActiveSupport::TestCase
      setup do
        @presentation = spina_conferences_presentations(:asymmetry_and_antisymmetry)
      end

      test 'presentation attributes must not be empty' do
        presentation = Presentation.new
        assert presentation.invalid?
        assert presentation.errors[:title].any?
        assert presentation.errors[:date].any?
        assert presentation.errors[:start_time].any?
        assert presentation.errors[:abstract].any?
        assert presentation.errors[:presenters].any?
      end
    end
  end
end
