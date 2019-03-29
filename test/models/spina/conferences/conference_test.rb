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
      end

      test 'start and finish dates must be dates' do
        assert_not @conference.errors[:start_date].any?
        assert_not @conference.errors[:finish_date].any?
        invalid_conference = Conference.new(institution: @conference.institution, start_date: 'Time.zone.today.iso8601',
                                            finish_date: 'Time.zone.yesterday.iso8601', rooms: @conference.rooms)
        assert invalid_conference.invalid?
        assert invalid_conference.errors[:start_date].any?
        assert invalid_conference.errors[:finish_date].any?
      end

      test 'finish date must be after start date' do
        assert_not @conference.errors[:start_date].any?
        assert_not @conference.errors[:finish_date].any?
        invalid_conference = Conference.new(institution: @conference.institution, start_date: Time.zone.today.iso8601,
                                            finish_date: Time.zone.yesterday.iso8601, rooms: @conference.rooms)
        assert invalid_conference.invalid?
        assert invalid_conference.errors[:finish_date].any?
      end

      test 'returns a name' do
        assert @conference.respond_to? :name
        assert @conference.name.class == String
      end
    end
  end
end
