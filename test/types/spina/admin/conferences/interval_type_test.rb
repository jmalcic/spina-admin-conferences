# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class IntervalTypeTest < ActiveSupport::TestCase
        setup { @interval_type = IntervalType.new }

        test 'casts strings' do
          assert_equal ::ActiveSupport::Duration.parse('P1Y'), @interval_type.cast('P1Y')
          assert_nil @interval_type.cast('O')
          assert_nil @interval_type.cast('')
        end

        test 'casts integers' do
          assert_equal ::ActiveSupport::Duration.build(1), @interval_type.cast(1)
          assert_nil @interval_type.cast(0.5)
        end

        test 'casts durations' do
          duration = ::ActiveSupport::Duration.parse('P1Y')
          assert_equal duration, @interval_type.cast(duration)
        end

        test 'casts other types to nil' do
          assert_nil @interval_type.cast([])
          assert_nil @interval_type.cast({})
          assert_nil @interval_type.cast(nil)
        end

        test 'serializes duration' do
          duration = ::ActiveSupport::Duration.parse('P1Y')
          assert_equal @interval_type.serialize(duration), duration.iso8601
        end

        test 'does not serialize other types' do
          assert_nil @interval_type.serialize(1)
          assert_nil @interval_type.serialize([])
          assert_nil @interval_type.serialize({})
          assert_nil @interval_type.serialize(nil)
        end
      end
    end
  end
end
