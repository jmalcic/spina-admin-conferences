# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferenceDateValidatorTest < ActiveSupport::TestCase
        setup do
          @validator = ConferenceDateValidator.new(attributes: [:start_datetime])
          @presentation = spina_admin_conferences_presentations(:asymmetry_and_antisymmetry)
        end

        test 'dates during conference are valid' do
          @presentation.start_datetime = @presentation.conference.dates.begin.iso8601
          assert_nil @validator.validate_each(@presentation, :start_datetime, @presentation.start_datetime)
        end

        test 'dates outside of conference are invalid' do
          @presentation.start_datetime = @presentation.conference.dates.begin - 1.day
          @validator.validate_each(@presentation, :start_datetime, @presentation.start_datetime)
          assert_includes @presentation.errors[:start_datetime], 'is not during the selected conference'
          @presentation.start_datetime = @presentation.conference.dates.end + 1.day
          @validator.validate_each(@presentation, :start_datetime, @presentation.start_datetime)
          assert_includes @presentation.errors[:start_datetime], 'is not during the selected conference'
        end

        test 'empty dates are valid' do
          @presentation.start_datetime = nil
          assert_nil @validator.validate_each(@presentation, :start_datetime, @presentation.start_datetime)
        end
      end
    end
  end
end
