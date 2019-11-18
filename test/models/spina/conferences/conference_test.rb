# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class ConferenceTest < ActiveSupport::TestCase
      setup { @conference = spina_conferences_conferences :university_of_atlantis_2017 }

      test 'conference attributes must not be empty' do
        conference = Conference.new
        assert conference.invalid?
        assert conference.errors[:start_date].any?
        assert conference.errors[:finish_date].any?
        assert conference.errors[:institution].any?
        assert conference.errors[:parts].any?
      end

      test 'start and finish dates must be dates' do
        assert @conference.valid?
        assert_not @conference.errors[:start_date].any?
        assert_not @conference.errors[:finish_date].any?
        @conference.start_date = 'Time.zone.yesterday.iso8601'
        @conference.finish_date = 'Time.zone.today.iso8601'
        assert @conference.invalid?
        assert @conference.errors[:start_date].any?
        assert @conference.errors[:finish_date].any?
      end

      test 'finish date must be after start date' do
        assert @conference.valid?
        assert_not @conference.errors[:start_date].any?
        assert_not @conference.errors[:finish_date].any?
        @conference.start_date = Time.zone.today.iso8601
        @conference.finish_date = Time.zone.yesterday.iso8601
        assert @conference.invalid?
        assert @conference.errors[:finish_date].any?
      end

      test 'start date is set correctly' do
        assert_equal @conference.start_date, @conference.dates.begin, 'is set after initialisation'
        @conference.update(dates: (@conference.dates.begin - 1.day)..@conference.dates.end)
        assert_equal @conference.start_date, @conference.dates.begin, 'is updated after save'
        new_conference = Conference.new
        assert_nil new_conference.start_date, 'is nil for new records'
      end

      test 'finish date is set correctly' do
        assert_equal @conference.finish_date, @conference.dates.end, 'is set after initialisation'
        @conference.update(dates: @conference.dates.begin..(@conference.dates.end + 1.day))
        assert_equal @conference.finish_date, @conference.dates.end, 'is updated after save'
        new_conference = Conference.new
        assert_nil new_conference.finish_date, 'is nil for new records'
      end

      test 'year is set correctly' do
        assert_equal @conference.year, @conference.dates.begin.year, 'is set after initialisation'
        @conference.update(dates: (@conference.dates.begin - 1.year)..@conference.dates.end)
        assert_equal @conference.year, @conference.dates.begin.year, 'is updated after save'
        new_conference = Conference.new
        assert_nil new_conference.year, 'is nil for new records'
      end

      test 'dates range is updated correctly' do
        start_date = @conference.start_date - 5.years
        finish_date = @conference.finish_date + 5.years
        @conference.update(start_date: start_date)
        @conference.reload
        assert_equal @conference.start_date, start_date
        @conference.update(finish_date: finish_date)
        @conference.reload
        assert_equal @conference.finish_date, finish_date
      end

      test 'returns a name' do
        assert @conference.name.class == String
      end

      test 'returns an iCal event' do
        assert @conference.to_ics.class == Icalendar::Event
        assert Conference.new.to_ics.class == Icalendar::Event
      end

      test 'returns an array of localized dates' do
        assert_equal @conference.localized_dates.first[:date], @conference.dates.begin.iso8601
        assert_equal @conference.localized_dates.first[:localization],
                     I18n.localize(@conference.dates.begin, format: :long)
        assert_equal @conference.localized_dates.size, @conference.dates.entries.size
        I18n.locale = :en
        assert_equal @conference.localized_dates.first[:localization],
                     I18n.localize(@conference.dates.begin, format: :long)
      end
    end
  end
end
