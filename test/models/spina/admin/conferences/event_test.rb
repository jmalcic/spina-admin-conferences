# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class EventTest < ActiveSupport::TestCase
        setup do
          @event = spina_admin_conferences_events :agm
          @new_event = Event.new
        end

        test 'translates name' do
          @event.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @event.name
          @event.name = 'bar'
          assert_equal 'bar', @event.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @event.name
        end

        test 'translates location' do
          @event.location = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @event.location
          @event.location = 'bar'
          assert_equal 'bar', @event.location
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @event.location
        end

        test 'translates description' do
          @event.description = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @event.description
          @event.description = 'bar'
          assert_equal 'bar', @event.description
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @event.description
        end

        test 'events have sorted scope' do
          assert_equal Event.i18n.order(:name), Event.sorted
        end

        test 'event has associated conference' do
          assert_not_nil @event.conference
          assert_nil @new_event.conference
        end

        test 'conference must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:conference]
          @event.conference = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:conference]
        end

        test 'name must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:name]
          @event.name = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:name]
        end

        test 'date must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:date]
          @event.date = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:date]
        end

        test 'start time must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:start_time]
          @event.start_time = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:start_time]
        end

        test 'start datetime must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:start_datetime]
          @event.start_datetime = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:start_datetime]
        end

        test 'finish time must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:finish_time]
          @event.finish_time = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:finish_time]
        end

        test 'finish datetime must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:finish_datetime]
          @event.finish_datetime = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:finish_datetime]
        end

        test 'location must not be empty' do
          assert @event.valid?
          assert_empty @event.errors[:location]
          @event.location = nil
          assert @event.invalid?
          assert_not_empty @event.errors[:location]
        end

        test 'date must be during conference' do
          assert @event.valid?
          assert_empty @event.errors[:date]
          @event.date = @event.conference.dates.max + 5.days
          assert @event.invalid?
          assert_not_empty @event.errors[:date]
        end

        test 'finish time must not be before start time' do
          assert @event.valid?
          assert_empty @event.errors[:finish_time]
          @event.finish_datetime = @event.start_datetime - 1.hour
          assert @event.invalid?
          assert_not_empty @event.errors[:finish_time]
        end

        test 'returns date' do
          assert_equal @event.start_datetime.to_date, @event.date
          assert_nil @new_event.date
        end

        test 'setting date updates start datetime' do
          assert_changes '@event.start_datetime' do
            @event.date = (@event.date + 1.day).iso8601
          end
          assert_changes '@event.start_datetime' do
            @event.date = nil
          end
          assert_nil @event.start_datetime
          assert_changes '@new_event.start_datetime' do
            @new_event.date = Date.today.iso8601 # rubocop:disable Rails/Date
          end
          assert_changes '@new_event.start_datetime' do
            @new_event.date = nil
          end
          assert_nil @new_event.start_datetime
        end

        test 'returns start time' do
          assert_equal @event.start_datetime,
                       @event.start_time
          assert_nil @new_event.start_time
        end

        test 'setting start time updates start datetime' do
          assert_changes '@event.start_datetime' do
            @event.start_time = (@event.start_time + 2.hours).to_formatted_s(:time)
          end
          assert_changes '@event.start_datetime' do
            @event.start_time = nil
          end
          assert_nil @event.start_datetime
          assert_changes '@new_event.start_datetime' do
            @new_event.start_time = DateTime.current.to_formatted_s(:time)
          end
          assert_changes '@new_event.start_datetime' do
            @new_event.start_time = nil
          end
          assert_nil @new_event.start_datetime
        end

        test 'returns an iCal event' do
          assert_instance_of Icalendar::Event, @event.to_ics
          assert_instance_of Icalendar::Event, @new_event.to_ics
        end
      end
    end
  end
end
