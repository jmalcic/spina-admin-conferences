# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationTypeTest < ActiveSupport::TestCase
        setup do
          @presentation_type_without_dependents = spina_admin_conferences_presentation_types :presentation_type_without_dependents
          @presentation_type_with_sessions = spina_admin_conferences_presentation_types :presentation_type_with_sessions
          @presentation_type_with_presentations = spina_admin_conferences_presentation_types :presentation_type_with_presentations
          @new_presentation_type = PresentationType.new
        end

        test 'translates name' do
          @presentation_type_without_dependents.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation_type_without_dependents.name
          @presentation_type_without_dependents.name = 'bar'
          assert_equal 'bar', @presentation_type_without_dependents.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation_type_without_dependents.name
        end

        test 'presentation types have sorted scope' do
          assert_equal PresentationType.i18n.order(:name), PresentationType.sorted
        end

        test 'duration must be an interval' do
          assert @presentation_type_without_dependents.valid?
          assert_empty @presentation_type_without_dependents.errors[:duration]
          @presentation_type_without_dependents.duration = '20 minutes'
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:duration]
        end

        test 'presentation type has associated conference' do
          assert_not_nil @presentation_type_without_dependents.conference
          assert_nil @new_presentation_type.conference
        end

        test 'presentation type has associated sessions' do
          assert_not_empty @presentation_type_with_sessions.sessions
          assert_empty @new_presentation_type.sessions
        end

        test 'presentation type has associated presentations' do
          assert_not_empty @presentation_type_with_presentations.presentations
          assert_empty @new_presentation_type.presentations
        end

        test 'does not destroy associated sessions' do
          assert_no_difference 'Session.count' do
            @presentation_type_with_sessions.destroy
          end
          assert_not_empty @presentation_type_with_sessions.errors[:base]
        end

        test 'conference must not be empty' do
          assert @presentation_type_without_dependents.valid?
          assert_empty @presentation_type_without_dependents.errors[:conference]
          @presentation_type_without_dependents.conference = nil
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:conference]
        end

        test 'name must not be empty' do
          assert @presentation_type_without_dependents.valid?
          assert_empty @presentation_type_without_dependents.errors[:name]
          @presentation_type_without_dependents.name = nil
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:name]
        end

        test 'minutes must not be empty' do
          assert @presentation_type_without_dependents.valid?
          assert_empty @presentation_type_without_dependents.errors[:name]
          @presentation_type_without_dependents.name = nil
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:name]
        end

        test 'duration must not be empty' do
          assert @presentation_type_without_dependents.valid?
          assert_empty @presentation_type_without_dependents.errors[:duration]
          @presentation_type_without_dependents.duration = nil
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:duration]
        end

        test 'minutes must be a greater than or equal to 1' do
          assert @presentation_type_without_dependents.valid?
          assert_empty @presentation_type_without_dependents.errors[:minutes]
          @presentation_type_without_dependents.duration = 0
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:minutes]
          @presentation_type_without_dependents.restore_attributes
          @presentation_type_without_dependents.duration = -1
          assert @presentation_type_without_dependents.invalid?
          assert_not_empty @presentation_type_without_dependents.errors[:minutes]
        end

        test 'returns minutes' do
          assert_equal @presentation_type_without_dependents.duration.to_i / ActiveSupport::Duration::PARTS_IN_SECONDS[:minutes],
                       @presentation_type_without_dependents.minutes
          assert_nil @new_presentation_type.minutes
        end

        test 'setting minutes updates duration' do
          assert_changes '@presentation_type_without_dependents.duration' do
            @presentation_type_without_dependents.minutes = 1000
          end
          assert_changes '@new_presentation_type.duration' do
            @new_presentation_type.minutes = 1000
          end
          assert_changes '@presentation_type_without_dependents.duration' do
            @presentation_type_without_dependents.minutes = nil
          end
        end
      end
    end
  end
end
