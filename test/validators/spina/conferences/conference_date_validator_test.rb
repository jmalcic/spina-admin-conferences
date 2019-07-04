# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class ConferenceDateValidatorTest < ActiveSupport::TestCase
      setup do
        @validator = ConferenceDateValidator.new(attributes: [:date])
        @presentation = spina_conferences_presentations(:asymmetry_and_antisymmetry)
      end

      test 'dates during conference are valid' do
        @presentation.date = @presentation.conference.dates.min
        assert_nil @validator.validate_each(@presentation, :date, @presentation.date)
      end

      test 'dates outside of conference are invalid' do
        @presentation.date = @presentation.conference.dates.min - 1.day
        assert_includes @validator.validate_each(@presentation, :date, @presentation.date),
                        'is not during the selected conference'
        @presentation.date = @presentation.conference.dates.max + 1.day
        assert_includes @validator.validate_each(@presentation, :date, @presentation.date),
                        'is not during the selected conference'
      end

      test 'empty dates are valid' do
        @presentation.date = nil
        assert_nil @validator.validate_each(@presentation, :date, @presentation.date)
      end
    end
  end
end
