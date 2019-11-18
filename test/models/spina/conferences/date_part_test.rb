# frozen_string_literal: true

require 'test_helper'

module Spina
  class DatePartTest < ActiveSupport::TestCase
    setup { @date_part = spina_conferences_date_parts :valid_date }

    test 'content must be a date' do
      assert @date_part.valid?
      assert_not @date_part.errors[:content].any?
      @date_part.content = 'invalid'
      assert @date_part.content.nil?
    end
  end
end
