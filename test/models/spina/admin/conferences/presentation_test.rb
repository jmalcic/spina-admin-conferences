# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationTest < ActiveSupport::TestCase
        include ActiveJob::TestHelper

        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry
          @new_presentation = Presentation.new
        end

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

        test 'presentations have sorted scope' do
          assert_equal Presentation.order(start_datetime: :desc), Presentation.sorted
        end

        test 'presentation has associated session' do
          assert_not_nil @presentation.session
          assert_nil @new_presentation.session
        end

        test 'presentation has associated presentation type' do
          assert_not_nil @presentation.presentation_type
          assert_nil @new_presentation.presentation_type
        end

        test 'presentation has associated room' do
          assert_not_nil @presentation.room
          assert_nil @new_presentation.room
        end

        test 'presentation has associated conference' do
          assert_not_nil @presentation.conference
          assert_nil @new_presentation.conference
        end

        test 'presentation has associated attachments' do
          assert_not_empty @presentation.attachments
          assert_empty @new_presentation.attachments
        end

        test 'presentation has associated presenters' do
          assert_not_empty @presentation.presenters
          assert_empty @new_presentation.presenters
        end

        # TODO: fix flaky test
        # test 'destroys associated attachments' do
        #   assert_difference 'PresentationAttachment.count', -@presentation.attachments.count do
        #     assert @presentation.destroy
        #   end
        # end

        test 'accepts nested attributes for attachments' do
          assert_changes '@presentation.attachments.first.attachment_type_id' do
            @presentation.assign_attributes attachments_attributes: { id: @presentation.attachments.first.id,
                                                                      attachment_type_id:
                                                                        PresentationAttachmentType.first.id }
          end
        end

        test 'session must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:session]
          @presentation.session = nil
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:session]
        end

        test 'title must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:title]
          @presentation.title = nil
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:title]
        end

        test 'date must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:date]
          @presentation.start_datetime = nil
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:date]
        end

        test 'start time must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:start_time]
          @presentation.start_datetime = nil
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:start_time]
        end

        test 'start datetime must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:start_datetime]
          @presentation.start_datetime = nil
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:start_datetime]
        end

        test 'abstract must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:abstract]
          @presentation.abstract = nil
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:abstract]
        end

        test 'presenters must not be empty' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:presenters]
          @presentation.presenters.clear
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:presenters]
        end

        test 'date must be during conference' do
          assert @presentation.valid?
          assert_empty @presentation.errors[:date]
          @presentation.start_datetime = @presentation.conference.finish_date.end_of_day + 1.second
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:date]
          @presentation.start_datetime = @presentation.conference.start_date.beginning_of_day - 1.second
          assert @presentation.invalid?
          assert_not_empty @presentation.errors[:date]
        end

        test 'validates associated presenters' do
          assert @presentation.valid?
          @presentation.presenters.build
          assert @presentation.invalid?
          assert_not_empty @presentation.presenters.last.errors
        end

        test 'validates associated attachments' do
          assert @presentation.valid?
          @presentation.attachments.build
          assert @presentation.invalid?
          assert_not_empty @presentation.attachments.last.errors
        end

        test 'performs import job' do
          assert_enqueued_jobs 1, only: PresentationImportJob do
            Presentation.import file_fixture('presentations.csv')
          end
        end

        test 'returns a name' do
          assert_not_empty @presentation.name
          assert_nil @new_presentation.name
        end

        test 'returns date' do
          assert_equal @presentation.start_datetime.to_date, @presentation.date
          assert_nil @new_presentation.date
        end

        test 'setting date updates start datetime' do
          assert_changes '@presentation.start_datetime' do
            @presentation.date = (@presentation.date + 1.day).iso8601
          end
          assert_changes '@presentation.start_datetime' do
            @presentation.date = nil
          end
          assert_nil @presentation.start_datetime
          assert_changes '@new_presentation.start_datetime' do
            @new_presentation.date = Date.today.iso8601
          end
          assert_changes '@new_presentation.start_datetime' do
            @new_presentation.date = nil
          end
          assert_nil @new_presentation.start_datetime
        end

        test 'returns start time' do
          assert_equal @presentation.start_datetime,
                       @presentation.start_time
          assert_nil @new_presentation.start_time
        end

        test 'setting start time updates start datetime' do
          assert_changes '@presentation.start_datetime' do
            @presentation.start_time = (@presentation.start_time + 2.hours).to_formatted_s(:time)
          end
          assert_changes '@presentation.start_datetime' do
            @presentation.start_time = nil
          end
          assert_nil @presentation.start_datetime
          assert_changes '@new_presentation.start_datetime' do
            @new_presentation.start_time = DateTime.current.to_formatted_s(:time)
          end
          assert_changes '@new_presentation.start_datetime' do
            @new_presentation.start_time = nil
          end
          assert_nil @new_presentation.start_datetime
        end

        test 'returns an iCal event' do
          assert_instance_of Icalendar::Event, @presentation.to_ics
          assert_instance_of Icalendar::Event, Presentation.new.to_ics
        end
      end
    end
  end
end
