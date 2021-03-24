# frozen_string_literal: true

require 'test_helper'

module Spina
  module Parts
    module Admin
      module Conferences
        class DateTest < ActiveSupport::TestCase
          setup do
            @date_part = Date.new(content: 10.days.from_now)
            @new_date_part = Date.new
          end

          test 'date has content' do
            assert_not_nil @date_part.content
            assert_nil @new_date_part.content
          end
        end
      end
    end
  end
end
