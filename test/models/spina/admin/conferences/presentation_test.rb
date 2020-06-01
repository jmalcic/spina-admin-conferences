# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationTest < ActiveSupport::TestCase
        setup { @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry }

        test 'translates title' do
          @presentation.title = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation.title
          @presentation.title = 'bar'
          assert_equal 'bar', @presentation.title
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation.title
        end

        test 'translates abstract' do
          @presentation.title = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation.title
          @presentation.title = 'bar'
          assert_equal 'bar', @presentation.title
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation.title
        end

        test 'presentation attributes must not be empty' do
          presentation = Presentation.new
          assert presentation.invalid?
          assert presentation.errors[:title].any?
          assert presentation.errors[:date].any?
          assert presentation.errors[:start_time].any?
          assert presentation.errors[:abstract].any?
          assert presentation.errors[:presenters].any?
          assert presentation.errors[:session].any?
        end

        test 'date must be during conference' do
          assert @presentation.valid?
          assert_not @presentation.errors[:date].any?
          @presentation.date = @presentation.conference.dates.max + 1.day
          assert @presentation.invalid?
          assert @presentation.errors[:date].any?
        end

        test 'returns a name' do
          assert_equal @presentation.name.class, String
        end

        test 'returns an iCal event' do
          assert_equal @presentation.to_ics.class, Icalendar::Event
          assert_equal Presentation.new.to_ics.class, Icalendar::Event
        end
      end
    end
  end
end
