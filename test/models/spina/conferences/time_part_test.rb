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

    test 'date is set correctly' do
      assert_equal @time_part.date, @time_part.content.to_date
      @time_part.update(content: @time_part.content - 1.day)
      @time_part.reload
      assert_equal @time_part.date, @time_part.content.to_date
      new_time_part = Spina::Conferences::TimePart.new
      assert_nil new_time_part.date
    end

    test 'time is set correctly' do
      assert_equal @time_part.time.strftime('%H:%M:%S'), @time_part.content.strftime('%H:%M:%S')
      @time_part.update(content: @time_part.content - 1.hour)
      @time_part.reload
      assert_equal @time_part.time.strftime('%H:%M:%S'), @time_part.content.strftime('%H:%M:%S')
      new_time_part = Spina::Conferences::TimePart.new
      assert_nil new_time_part.time
    end

    test 'content is updated correctly' do
      date = @time_part.date - 1.day
      time = @time_part.time + 5.minutes
      @time_part.update(date: date)
      @time_part.reload
      assert_equal @time_part.date, date
      @time_part.update(time: time)
      @time_part.reload
      assert_equal @time_part.time, time
    end
  end
end
