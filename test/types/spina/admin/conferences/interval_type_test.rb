# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class IntervalTypeTest < ActiveSupport::TestCase
        setup { @interval_type = IntervalType.new }

        test 'casts strings' do
          assert_equal @interval_type.cast('P1Y'), ::ActiveSupport::Duration.parse('P1Y')
          assert_nil @interval_type.cast('O')
          assert_nil @interval_type.cast('')
        end

        test 'casts durations' do
          duration = ::ActiveSupport::Duration.parse('P1Y')
          assert_equal @interval_type.cast(duration), duration
        end

        test 'casts other types' do
          assert_equal @interval_type.cast(1), 1
          assert_equal @interval_type.cast([]), []
          assert_equal @interval_type.cast({}), {}
          assert_nil @interval_type.cast(nil)
        end

        test 'serializes duration' do
          duration = ::ActiveSupport::Duration.parse('P1Y')
          assert_equal @interval_type.serialize(duration), duration.iso8601
        end

        test 'serializes other types' do
          assert_equal @interval_type.serialize(1), 1
          assert_equal @interval_type.serialize([]), []
          assert_equal @interval_type.serialize({}), {}
          assert_nil @interval_type.serialize(nil)
        end
      end
    end
  end
end
