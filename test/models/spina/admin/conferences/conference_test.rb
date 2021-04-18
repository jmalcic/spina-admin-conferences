# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferenceTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017 # rubocop:disable Naming/VariableNumber
          @empty_conference = spina_admin_conferences_conferences :empty_conference
          @new_conference = Conference.new
        end

        test 'translates name' do
          @conference.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @conference.name
          @conference.name = 'bar'
          assert_equal 'bar', @conference.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @conference.name
        end

        test 'conferences have sorted scope' do
          assert_equal Conference.order(dates: :desc), Conference.sorted
        end

        test 'conference has associated presentation types' do
          assert_not_empty @conference.presentation_types
          assert_empty @new_conference.presentation_types
        end

        test 'conference has associated events' do
          assert_not_empty @conference.events
          assert_empty @new_conference.events
        end

        test 'conference has associated sessions' do
          assert_not_empty @conference.sessions
          assert_empty @new_conference.sessions
        end

        test 'conference has associated presentations' do
          assert_not_empty @conference.presentations
          assert_empty @new_conference.presentations
        end

        test 'conference has associated rooms' do
          assert_not_empty @conference.rooms
          assert_empty @new_conference.rooms
        end

        test 'conference has associated institutions' do
          assert_not_empty @conference.institutions
          assert_empty @new_conference.institutions
        end

        test 'conference has associated delegates' do
          assert_not_empty @conference.delegates
          assert_empty @new_conference.delegates
        end

        test 'does not destroy associated presentation types' do
          assert_no_difference 'PresentationType.count' do
            @conference.destroy
          end
          assert_not_empty @conference.errors[:base]
        end

        test 'destroys associated events' do
          assert_difference 'Event.count', -2 do
            @empty_conference.destroy
          end
          assert_empty @empty_conference.errors[:base]
        end

        test 'name must not be empty' do
          assert @conference.valid?
          assert_empty @conference.errors[:name]
          @conference.name = nil
          assert @conference.invalid?
          assert_not_empty @conference.errors[:name]
        end

        test 'start date must not be empty' do
          assert @conference.valid?
          assert_empty @conference.errors[:start_date]
          @conference.dates = nil..@conference.finish_date
          assert @conference.invalid?
          assert_not_empty @conference.errors[:start_date]
        end

        test 'finish date must not be empty' do
          assert @conference.valid?
          assert_empty @conference.errors[:finish_date]
          @conference.dates = @conference.start_date..nil
          assert @conference.invalid?
          assert_not_empty @conference.errors[:finish_date]
        end

        test 'year must not be empty' do
          assert @conference.valid?
          assert_empty @conference.errors[:year]
          @conference.dates = nil
          assert @conference.invalid?
          assert_not_empty @conference.errors[:year]
        end

        test 'finish date must be after start date' do
          assert @conference.valid?
          assert_empty @conference.errors[:finish_date]
          @conference.dates = Time.zone.today.iso8601..Time.zone.yesterday.iso8601
          assert @conference.invalid?
          assert_not_empty @conference.errors[:finish_date]
        end

        test 'validates associated presentation types' do
          assert @conference.valid?
          @conference.presentation_types.build
          assert @conference.invalid?
          assert_not_empty @conference.presentation_types.last.errors
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
          assert_equal @conference.dates.min, @conference.start_date
          assert_nil @new_conference.start_date
        end

        test 'updating start date updates dates' do
          assert_changes '@conference.dates' do
            @conference.start_date = (@conference.start_date - 1.day).iso8601
          end
          assert_changes '@conference.dates' do
            @conference.start_date = nil
          end
          assert_changes '@new_conference.dates' do
            @new_conference.start_date = Date.today.iso8601 # rubocop:disable Rails/Date
          end
          assert_changes '@new_conference.dates' do
            @new_conference.start_date = nil
          end
        end

        test 'conference returns a finish date' do
          assert_equal @conference.dates.max, @conference.finish_date
          assert_nil @new_conference.finish_date
        end

        test 'updating finish date updates dates' do
          assert_changes '@conference.dates' do
            @conference.finish_date = (@conference.finish_date + 1.day).iso8601
          end
          assert_changes '@conference.dates' do
            @conference.finish_date = nil
          end
          assert_changes '@new_conference.dates' do
            @new_conference.finish_date = Date.tomorrow.iso8601
          end
          assert_changes '@new_conference.dates' do
            @new_conference.finish_date = nil
          end
        end

        test 'conference returns year' do
          assert_equal @conference.dates.begin.year, @conference.year
          assert_nil @new_conference.year
        end

        test 'returns an array of localized dates' do
          assert_equal @conference.dates.begin.iso8601, @conference.localized_dates.first[:date]
          assert_equal I18n.localize(@conference.dates.begin, format: :long),
                       @conference.localized_dates.first[:localization]
          assert_equal @conference.dates.entries.size, @conference.localized_dates.size
          I18n.locale = :ja
          assert_equal I18n.localize(@conference.dates.begin, format: :long),
                       @conference.localized_dates.first[:localization]
          assert_nil @new_conference.localized_dates
          I18n.locale = I18n.default_locale
        end

        test 'returns a location' do
          assert_instance_of String, @conference.location
          assert_instance_of String, @new_conference.location
        end

        test 'returns an iCal event' do
          assert_instance_of Icalendar::Event, @conference.to_event
          assert_instance_of Icalendar::Event, @new_conference.to_event
        end

        test 'finish date saved correctly' do
          assert_changes '@conference.finish_date', to: @conference.finish_date + 1.day do
            @conference.finish_date = (@conference.finish_date + 1.day).iso8601
            @conference.save
            @conference.reload
          end
        end
      end
    end
  end
end
