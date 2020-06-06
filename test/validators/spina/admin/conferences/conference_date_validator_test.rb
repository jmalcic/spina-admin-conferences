# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferenceDateValidatorTest < ActiveSupport::TestCase
        setup do
          @validator = ConferenceDateValidator.new(attributes: [:date])
          @presentation = spina_admin_conferences_presentations(:asymmetry_and_antisymmetry)
        end

        test 'dates during conference are valid' do
          @presentation.date = @presentation.conference.dates.begin.iso8601
          assert_nil @validator.validate_each(@presentation, :date, @presentation.date)
        end

        test 'dates outside of conference are invalid' do
          @presentation.date = (@presentation.conference.dates.begin - 1.day).iso8601
          assert_includes @validator.validate_each(@presentation, :date, @presentation.date),
                          'is not during the selected conference'
          @presentation.date = (@presentation.conference.dates.end + 1.day).iso8601
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
end
