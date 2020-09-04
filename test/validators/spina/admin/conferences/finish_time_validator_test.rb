# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class FinishTimeValidatorTest < ActiveSupport::TestCase
        setup do
          @validator = FinishTimeValidator.new(attributes: [:finish_time])
          @event = spina_admin_conferences_events(:agm)
        end

        test 'dates greater than or equal to the start time are valid' do
          @event.finish_datetime = @event.start_time + 1.hour
          assert_nil @validator.validate_each(@event, :finish_time, @event.finish_time)
          @event.finish_datetime = @event.start_time
          assert_nil @validator.validate_each(@event, :finish_time, @event.finish_time)
        end

        test 'dates before the start time are invalid' do
          @event.finish_datetime = @event.start_time - 1.hour
          assert_includes @validator.validate_each(@event, :finish_time, @event.finish_time), 'is before start time'
        end

        test 'empty times are valid' do
          @event.finish_datetime = nil
          assert_nil @validator.validate_each(@event, :finish_time, @event.finish_time)
        end

        test 'empty start times are valid' do
          @event.finish_datetime = @event.start_time - 1.hour
          @event.start_datetime = nil
          assert_nil @validator.validate_each(@event, :finish_time, @event.finish_time)
        end
      end
    end
  end
end
