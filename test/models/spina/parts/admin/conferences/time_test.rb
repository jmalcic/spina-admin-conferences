# frozen_string_literal: true

require 'test_helper'

module Spina
  module Parts
    module Admin
      module Conferences
        class TimeTest < ActiveSupport::TestCase
          setup do
            @time_part = Time.new(content: 10.years.from_now)
            @new_time_part = Time.new
          end

          test 'time has content' do
            assert_not_nil @time_part.content
            assert_nil @new_time_part.content
          end
        end
      end
    end
  end
end
