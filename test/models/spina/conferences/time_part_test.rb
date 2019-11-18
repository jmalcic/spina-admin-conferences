# frozen_string_literal: true

require 'test_helper'

module Spina
  class TimePartTest < ActiveSupport::TestCase
    setup { @time_part = spina_conferences_time_parts :valid_time }

    test 'content must be a time' do
      assert @time_part.valid?
      assert_not @time_part.errors[:content].any?
      @time_part.content = 'invalid'
      assert @time_part.content.nil?
    end
  end
end
