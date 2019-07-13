# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PresentationTest < ActiveSupport::TestCase
      setup { @presentation = spina_conferences_presentations :asymmetry_and_antisymmetry }

      test 'presentation attributes must not be empty' do
        presentation = Presentation.new
        assert presentation.invalid?
        assert presentation.errors[:title].any?
        assert presentation.errors[:date].any?
        assert presentation.errors[:start_time].any?
        assert presentation.errors[:abstract].any?
        assert presentation.errors[:presenters].any?
        assert presentation.errors[:parts].any?
      end

      test 'date must be during conference' do
        assert @presentation.valid?
        assert_not @presentation.errors[:date].any?
        @presentation.date = @presentation.conference.dates.max + 1.day
        assert @presentation.invalid?
        assert @presentation.errors[:date].any?
      end

      test 'returns a name' do
        assert @presentation.name.class == String
      end

      test 'returns an iCal event' do
        assert @presentation.to_ics.class == Icalendar::Event
        assert Presentation.new.to_ics.class == Icalendar::Event
      end
    end
  end
end
