# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
        include ActiveJob::TestHelper

        setup do
          @presentation_without_dependents = spina_admin_conferences_presentations :presentation_without_dependents
          @presentation_with_attachments = spina_admin_conferences_presentations :presentation_with_attachments
          @presentation_with_delegations = spina_admin_conferences_presentations :presentation_with_delegations
          @new_presentation = Presentation.new
        end

        test 'translates title' do
          @presentation_without_dependents.title = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation_without_dependents.title
          @presentation_without_dependents.title = 'bar'
          assert_equal 'bar', @presentation_without_dependents.title
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation_without_dependents.title
        end

        test 'translates abstract' do
          @presentation_without_dependents.abstract = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation_without_dependents.abstract.to_plain_text
          @presentation_without_dependents.abstract = 'bar'
          assert_equal 'bar', @presentation_without_dependents.abstract.to_plain_text
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation_without_dependents.abstract.to_plain_text
        end

        test 'presentations have sorted scope' do
          assert_equal Presentation.order(start_datetime: :desc), Presentation.sorted
        end

        test 'presentation has associated session' do
          assert_not_nil @presentation_without_dependents.session
          assert_nil @new_presentation.session
        end

        test 'presentation has associated presentation type' do
          assert_not_nil @presentation_without_dependents.presentation_type
          assert_nil @new_presentation.presentation_type
        end

        test 'presentation has associated room' do
          assert_not_nil @presentation_without_dependents.room
          assert_nil @new_presentation.room
        end

        test 'presentation has associated conference' do
          assert_not_nil @presentation_without_dependents.conference
          assert_nil @new_presentation.conference
        end

        test 'presentation has associated attachments' do
          assert_not_empty @presentation_with_attachments.attachments
          assert_empty @new_presentation.attachments
        end

        test 'presentation has associated authorships' do
          assert_not_empty @presentation_with_delegations.authorships
          assert_empty @new_presentation.authorships
        end

        test 'presentation has associated presenters' do
          assert_not_empty @presentation_with_delegations.presenters
          assert_empty @new_presentation.presenters
        end

        test 'destroys associated attachments' do
          assert_difference 'PresentationAttachment.count', -1 do
            assert @presentation_with_attachments.destroy
          end
        end

        test 'destroys associated authorships' do
          assert_difference 'Authorship.count', -1 do
            assert @presentation_with_delegations.destroy
          end
        end

        test 'accepts nested attributes for attachments' do
          assert_changes '@presentation_with_attachments.attachments.first.attachment_type_id' do
            @presentation_with_attachments.assign_attributes attachments_attributes: { id: @presentation_with_attachments.attachments.first.id,
                                                                                       attachment_type_id: rand(999_999) }
          end
        end

        test 'accepts nested attributes for authorships' do
          assert_changes '@presentation_with_delegations.authorships.first.delegation_id' do
            @presentation_with_delegations.assign_attributes authorships_attributes: { id: @presentation_with_delegations.authorships.first.id,
                                                                                       delegation_id: rand(999_999) }
          end
        end

        test 'session must not be empty' do
          assert @presentation_with_delegations.valid?
          assert_empty @presentation_with_delegations.errors[:session]
          @presentation_with_delegations.session = nil
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:session]
        end

        test 'title must not be empty' do
          assert @presentation_with_delegations.valid?
          assert_empty @presentation_with_delegations.errors[:title]
          @presentation_with_delegations.title = nil
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:title]
        end

        test 'start datetime must not be empty' do
          assert @presentation_with_delegations.valid?
          assert_empty @presentation_with_delegations.errors[:start_datetime]
          @presentation_with_delegations.start_datetime = nil
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:start_datetime]
        end

        test 'abstract must not be empty' do
          assert @presentation_with_delegations.valid?
          assert_empty @presentation_with_delegations.errors[:abstract]
          @presentation_with_delegations.abstract = nil
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:abstract]
        end

        test 'authorships must not be empty' do
          assert @presentation_with_delegations.valid?
          assert_empty @presentation_with_delegations.errors[:authorships]
          @presentation_with_delegations.authorships.clear
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:authorships]
        end

        test 'start datetime must be during conference' do
          assert @presentation_with_delegations.valid?
          assert_empty @presentation_with_delegations.errors[:start_datetime]
          @presentation_with_delegations.start_datetime = @presentation_with_delegations.conference.finish_date.end_of_day + 1.second
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:start_datetime]
          @presentation_with_delegations.start_datetime = @presentation_with_delegations.conference.start_date.beginning_of_day - 1.second
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.errors[:start_datetime]
        end

        test 'validates associated authorships' do
          assert @presentation_with_delegations.valid?
          @presentation_with_delegations.authorships.build
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.authorships.last.errors
        end

        test 'validates associated attachments' do
          assert @presentation_with_delegations.valid?
          @presentation_with_delegations.attachments.build
          assert @presentation_with_delegations.invalid?
          assert_not_empty @presentation_with_delegations.attachments.last.errors
        end

        test 'performs import job' do
          file_fixture('presentations.csv.erb').read
            .then { |file| ERB.new(file).result(binding) }
            .then { |result| Pathname.new(File.join(file_fixture_path, 'presentations.csv')).write(result) }
          assert_enqueued_jobs 1, only: PresentationImportJob do
            Presentation.import file_fixture('presentations.csv')
          end
        end

        test 'returns a name' do
          assert_not_empty @presentation_without_dependents.name
          assert_nil @new_presentation.name
        end

        test 'returns date' do
          assert_equal @presentation_without_dependents.start_datetime.to_date, @presentation_without_dependents.date
          assert_nil @new_presentation.date
        end

        test 'returns start time' do
          assert_equal @presentation_without_dependents.start_datetime, @presentation_without_dependents.start_time
          assert_nil @new_presentation.start_time
        end

        test 'returns finish datetime' do
          assert_equal @presentation_without_dependents.start_datetime + @presentation_without_dependents.presentation_type.duration,
                       @presentation_without_dependents.finish_datetime
          assert_nil @new_presentation.finish_datetime
        end

        test 'returns a time zone period' do
          assert_kind_of TZInfo::TimezonePeriod, @presentation_without_dependents.time_zone_period
          assert_nil @new_presentation.time_zone_period
        end

        test 'returns an iCal event' do
          assert_instance_of Icalendar::Event, @presentation_without_dependents.to_event
          assert_instance_of Icalendar::Event, @new_presentation.to_event
        end
      end
    end
  end
end
