# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationTypeTest < ActiveSupport::TestCase
        setup do
          @presentation_type = spina_admin_conferences_presentation_types :oral_1
          @new_presentation_type = PresentationType.new
        end

        test 'presentation types have sorted scope' do
          assert_equal PresentationType.i18n.order(:name), PresentationType.sorted
        end

        test 'duration must be an interval' do
          assert @presentation_type.valid?
          assert_empty @presentation_type.errors[:duration]
          @presentation_type.duration = 0.5
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:duration]
        end

        test 'presentation type has associated conference' do
          assert_not_nil @presentation_type.conference
          assert_nil @new_presentation_type.conference
        end

        test 'presentation type has associated sessions' do
          assert_not_empty @presentation_type.sessions
          assert_empty @new_presentation_type.sessions
        end

        test 'presentation type has associated presentations' do
          assert_not_empty @presentation_type.presentations
          assert_empty @new_presentation_type.presentations
        end

        test 'does not destroy associated session' do
          assert_no_difference 'Session.count' do
            @presentation_type.destroy
          end
          assert_not_empty @presentation_type.errors[:base]
        end

        test 'conference must not be empty' do
          assert @presentation_type.valid?
          assert_empty @presentation_type.errors[:conference]
          @presentation_type.conference = nil
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:conference]
        end

        test 'name must not be empty' do
          assert @presentation_type.valid?
          assert_empty @presentation_type.errors[:name]
          @presentation_type.name = nil
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:name]
        end

        test 'minutes must not be empty' do
          assert @presentation_type.valid?
          assert_empty @presentation_type.errors[:name]
          @presentation_type.name = nil
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:name]
        end

        test 'duration must not be empty' do
          assert @presentation_type.valid?
          assert_empty @presentation_type.errors[:duration]
          @presentation_type.duration = nil
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:duration]
        end

        test 'minutes must be a greater than or equal to 1' do
          assert @presentation_type.valid?
          assert_empty @presentation_type.errors[:minutes]
          @presentation_type.duration = 0
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:minutes]
          @presentation_type.restore_attributes
          @presentation_type.duration = -1
          assert @presentation_type.invalid?
          assert_not_empty @presentation_type.errors[:minutes]
        end

        test 'returns minutes' do
          assert_equal @presentation_type.duration.to_i / ActiveSupport::Duration::PARTS_IN_SECONDS[:minutes],
                       @presentation_type.minutes
          assert_nil @new_presentation_type.minutes
        end

        test 'setting minutes updates duration' do
          assert_changes '@presentation_type.duration' do
            @presentation_type.minutes = 1000
          end
          assert_changes '@new_presentation_type.duration' do
            @new_presentation_type.minutes = 1000
          end
          assert_changes '@presentation_type.duration' do
            @presentation_type.minutes = nil
          end
        end
      end
    end
  end
end
