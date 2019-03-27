# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class ConferenceTest < ActiveSupport::TestCase
      setup do
        @conference = spina_conferences_conferences(:university_of_atlantis_2017)
      end

      test 'conference attributes must not be empty' do
        conference = Conference.new
        assert conference.invalid?
        assert conference.errors[:start_date].any?
        assert conference.errors[:finish_date].any?
        assert conference.errors[:institution].any?
      end
    end
  end
end
