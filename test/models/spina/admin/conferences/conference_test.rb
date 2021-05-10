# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferenceTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
        setup do
          @conference_with_presentations = spina_admin_conferences_conferences :conference_with_presentations
          @empty_conference = spina_admin_conferences_conferences :conference_without_dependents
          @conference_with_presentations_with_events = spina_admin_conferences_conferences :conference_with_events
          @conference_with_presentations_with_presentation_types = spina_admin_conferences_conferences :conference_with_presentation_types
          @conference_with_presentations_with_presentations = spina_admin_conferences_conferences :conference_with_presentations
          @conference_with_presentations_with_parts = spina_admin_conferences_conferences :conference_with_parts
          @conference_with_presentations_with_sessions = spina_admin_conferences_conferences :conference_with_sessions
          @conference_with_presentations_with_delegations = spina_admin_conferences_conferences :conference_with_delegations
          @new_conference = Conference.new
        end

        test 'translates name' do
          @conference_with_presentations.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @conference_with_presentations.name
          @conference_with_presentations.name = 'bar'
          assert_equal 'bar', @conference_with_presentations.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @conference_with_presentations.name
        end

        test 'conferences have sorted scope' do
          assert_equal Conference.order(dates: :desc), Conference.sorted
        end

        test 'conference has associated presentation types' do
          assert_not_empty @conference_with_presentations_with_presentation_types.presentation_types
          assert_empty @new_conference.presentation_types
        end

        test 'conference has associated events' do
          assert_not_empty @conference_with_presentations_with_events.events
          assert_empty @new_conference.events
        end

        test 'conference has associated sessions' do
          assert_not_empty @conference_with_presentations_with_sessions.sessions
          assert_empty @new_conference.sessions
        end

        test 'conference has associated presentations' do
          assert_not_empty @conference_with_presentations.presentations
          assert_empty @new_conference.presentations
        end

        test 'conference has associated rooms' do
          assert_not_empty @conference_with_presentations.rooms
          assert_empty @new_conference.rooms
        end

        test 'conference has associated institutions' do
          assert_not_empty @conference_with_presentations.institutions
          assert_empty @new_conference.institutions
        end

        test 'conference has associated delegates' do
          assert_not_empty @conference_with_presentations_with_delegations.delegates
          assert_empty @new_conference.delegates
        end

        test 'does not destroy associated presentation types' do
          assert_no_difference 'PresentationType.count' do
            assert_not @conference_with_presentations_with_presentation_types.destroy
          end
          assert_not_empty @conference_with_presentations_with_presentation_types.errors[:base]
        end

        test 'destroys associated events' do
          assert_difference 'Event.count', -1 do
            assert @conference_with_presentations_with_events.destroy
          end
          assert_empty @conference_with_presentations_with_events.errors[:base]
        end

        test 'name must not be empty' do
          assert @conference_with_presentations.valid?
          assert_empty @conference_with_presentations.errors[:name]
          @conference_with_presentations.name = nil
          assert @conference_with_presentations.invalid?
          assert_not_empty @conference_with_presentations.errors[:name]
        end

        test 'start date must not be empty' do
          assert @conference_with_presentations.valid?
          assert_empty @conference_with_presentations.errors[:start_date]
          @conference_with_presentations.dates = nil..@conference_with_presentations.finish_date
          assert @conference_with_presentations.invalid?
          assert_not_empty @conference_with_presentations.errors[:start_date]
        end

        test 'finish date must not be empty' do
          assert @conference_with_presentations.valid?
          assert_empty @conference_with_presentations.errors[:finish_date]
          @conference_with_presentations.dates = @conference_with_presentations.start_date..nil
          assert @conference_with_presentations.invalid?
          assert_not_empty @conference_with_presentations.errors[:finish_date]
        end

        test 'year must not be empty' do
          assert @conference_with_presentations.valid?
          assert_empty @conference_with_presentations.errors[:year]
          @conference_with_presentations.dates = nil
          assert @conference_with_presentations.invalid?
          assert_not_empty @conference_with_presentations.errors[:year]
        end

        test 'finish date must be after start date' do
          assert @conference_with_presentations.valid?
          assert_empty @conference_with_presentations.errors[:finish_date]
          @conference_with_presentations.dates = Time.zone.today.iso8601..Time.zone.yesterday.iso8601
          assert @conference_with_presentations.invalid?
          assert_not_empty @conference_with_presentations.errors[:finish_date]
        end

        test 'validates associated presentation types' do
          assert @conference_with_presentations.valid?
          @conference_with_presentations.presentation_types.build
          assert @conference_with_presentations.invalid?
          assert_not_empty @conference_with_presentations.presentation_types.last.errors
        end

        test 'conferences return time zone periods' do
          assert_kind_of Array, Conference.time_zone_periods
          assert_kind_of Array, Conference.none.time_zone_periods
        end

        test 'conferences return an iCal calendar' do
          assert_kind_of String, Conference.to_ics
          assert_kind_of String, Conference.none.to_ics
        end

        test 'conference returns a start date' do
          assert_equal @conference_with_presentations.dates.min, @conference_with_presentations.start_date
          assert_nil @new_conference.start_date
        end

        test 'updating start date updates dates' do
          assert_changes '@conference_with_presentations.dates' do
            @conference_with_presentations.start_date = (@conference_with_presentations.start_date - 1.day).iso8601
          end
          assert_changes '@conference_with_presentations.dates' do
            @conference_with_presentations.start_date = nil
          end
          assert_changes '@new_conference.dates' do
            @new_conference.start_date = Date.today.iso8601 # rubocop:disable Rails/Date
          end
          assert_changes '@new_conference.dates' do
            @new_conference.start_date = nil
          end
        end

        test 'conference returns a finish date' do
          assert_equal @conference_with_presentations.dates.max, @conference_with_presentations.finish_date
          assert_nil @new_conference.finish_date
        end

        test 'updating finish date updates dates' do
          assert_changes '@conference_with_presentations.dates' do
            @conference_with_presentations.finish_date = (@conference_with_presentations.finish_date + 1.day).iso8601
          end
          assert_changes '@conference_with_presentations.dates' do
            @conference_with_presentations.finish_date = nil
          end
          assert_changes '@new_conference.dates' do
            @new_conference.finish_date = Date.tomorrow.iso8601
          end
          assert_changes '@new_conference.dates' do
            @new_conference.finish_date = nil
          end
        end

        test 'conference returns year' do
          assert_equal @conference_with_presentations.dates.begin.year, @conference_with_presentations.year
          assert_nil @new_conference.year
        end

        test 'returns an array of localized dates' do
          assert_equal @conference_with_presentations.dates.begin.iso8601, @conference_with_presentations.localized_dates.first[:date]
          assert_equal I18n.localize(@conference_with_presentations.dates.begin, format: :long),
                       @conference_with_presentations.localized_dates.first[:localization]
          assert_equal @conference_with_presentations.dates.entries.size, @conference_with_presentations.localized_dates.size
          I18n.locale = :ja
          assert_equal I18n.localize(@conference_with_presentations.dates.begin, format: :long),
                       @conference_with_presentations.localized_dates.first[:localization]
          assert_nil @new_conference.localized_dates
          I18n.locale = I18n.default_locale
        end

        test 'returns a location' do
          assert_instance_of String, @conference_with_presentations.location
          assert_instance_of String, @new_conference.location
        end

        test 'returns an iCal event' do
          assert_instance_of Icalendar::Event, @conference_with_presentations.to_event
          assert_instance_of Icalendar::Event, @new_conference.to_event
        end

        test 'returns a time zone period' do
          assert_kind_of TZInfo::TimezonePeriod, @conference_with_presentations.time_zone_period
          assert_nil @new_conference.time_zone_period
        end

        test 'returns an iCal calendar' do
          assert_kind_of String, @conference_with_presentations.to_ics
          assert_nil @new_conference.to_ics
        end

        test 'finish date saved correctly' do
          assert_changes '@conference_with_presentations.finish_date', to: @conference_with_presentations.finish_date + 1.day do
            @conference_with_presentations.finish_date = (@conference_with_presentations.finish_date + 1.day).iso8601
            @conference_with_presentations.save
            @conference_with_presentations.reload
          end
        end
      end
    end
  end
end
