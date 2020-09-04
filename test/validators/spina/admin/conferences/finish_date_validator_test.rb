# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class FinishDateValidatorTest < ActiveSupport::TestCase
        setup do
          @validator = FinishDateValidator.new(attributes: [:finish_date])
          @conference = spina_admin_conferences_conferences(:university_of_atlantis_2017)
        end

        test 'dates greater than or equal to the start date are valid' do
          @conference.finish_date = (@conference.start_date + 1.day).iso8601
          assert_nil @validator.validate_each(@conference, :finish_date, @conference.finish_date)
          @conference.finish_date = @conference.start_date.iso8601
          assert_nil @validator.validate_each(@conference, :finish_date, @conference.finish_date)
        end

        test 'dates before the start date are invalid' do
          @conference.finish_date = (@conference.start_date - 1.day).iso8601
          assert_includes @validator.validate_each(@conference, :finish_date, @conference.finish_date),
                          'is before start date'
        end

        test 'empty dates are valid' do
          @conference.finish_date = nil
          assert_nil @validator.validate_each(@conference, :finish_date, @conference.finish_date)
        end

        test 'empty start dates are valid' do
          @conference.finish_date = (@conference.start_date - 1.day).iso8601
          @conference.start_date = nil
          assert_nil @validator.validate_each(@conference, :finish_date, @conference.finish_date)
        end
      end
    end
  end
end
