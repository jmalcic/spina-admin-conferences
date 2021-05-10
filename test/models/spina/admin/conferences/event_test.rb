# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class EventTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
        setup do
          @valid_event = spina_admin_conferences_events :valid_event
          @new_event = Event.new
        end

        test 'translates name' do
          @valid_event.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @valid_event.name
          @valid_event.name = 'bar'
          assert_equal 'bar', @valid_event.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @valid_event.name
        end

        test 'translates location' do
          @valid_event.location = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @valid_event.location
          @valid_event.location = 'bar'
          assert_equal 'bar', @valid_event.location
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @valid_event.location
        end

        test 'translates description' do
          @valid_event.description = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @valid_event.description.to_plain_text
          @valid_event.description = 'bar'
          assert_equal 'bar', @valid_event.description.to_plain_text
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @valid_event.description.to_plain_text
        end

        test 'events have sorted scope' do
          assert_equal Event.i18n.order(:name), Event.sorted
        end

        test 'event has associated conference' do
          assert_not_nil @valid_event.conference
          assert_nil @new_event.conference
        end

        test 'conference must not be empty' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:conference]
          @valid_event.conference = nil
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:conference]
        end

        test 'name must not be empty' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:name]
          @valid_event.name = nil
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:name]
        end

        test 'start datetime must not be empty' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:start_datetime]
          @valid_event.start_datetime = nil
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:start_datetime]
        end

        test 'finish datetime must not be empty' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:finish_datetime]
          @valid_event.finish_datetime = nil
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:finish_datetime]
        end

        test 'location must not be empty' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:location]
          @valid_event.location = nil
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:location]
        end

        test 'start datetime must be during conference' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:start_datetime]
          @valid_event.start_datetime = @valid_event.conference.dates.max + 5.days
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:start_datetime]
        end

        test 'finish datetime must be during conference' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:finish_datetime]
          @valid_event.finish_datetime = @valid_event.conference.dates.max + 5.days
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:finish_datetime]
        end

        test 'finish datetime must not be before start time' do
          assert @valid_event.valid?
          assert_empty @valid_event.errors[:finish_datetime]
          @valid_event.finish_datetime = @valid_event.start_datetime - 1.hour
          assert @valid_event.invalid?
          assert_not_empty @valid_event.errors[:finish_datetime]
        end

        test 'returns start time' do
          assert_equal @valid_event.start_time, @valid_event.start_datetime
          assert_nil @new_event.start_datetime
        end

        test 'returns date' do
          assert_equal @valid_event.start_datetime.to_date, @valid_event.date
          assert_nil @new_event.date
        end

        test 'returns a time zone period' do
          assert_kind_of TZInfo::TimezonePeriod, @valid_event.time_zone_period
          assert_nil @new_event.time_zone_period
        end

        test 'returns an iCal event' do
          assert_instance_of Icalendar::Event, @valid_event.to_event
          assert_instance_of Icalendar::Event, @new_event.to_event
        end
      end
    end
  end
end
