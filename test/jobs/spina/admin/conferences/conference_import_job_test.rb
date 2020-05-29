# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class ConferenceImportJobTest < ActiveJob::TestCase
      include ::Spina::Conferences

      test 'that number of conferences changes' do
        assert_difference 'Conference.count', 2 do
          ConferenceImportJob.perform_now File.open(file_fixture('conferences.csv'))
        end
      end

      test 'that number of room possessions changes' do
        assert_difference 'RoomPossession.count', 6 do
          ConferenceImportJob.perform_now File.open(file_fixture('conferences.csv'))
        end
      end

      test 'conference import scheduling' do
        assert_enqueued_with job: ConferenceImportJob do
          Conference.import File.open(file_fixture('conferences.csv'))
        end
      end

      test 'conference import performing' do
        assert_performed_with job: ConferenceImportJob do
          Conference.import File.open(file_fixture('conferences.csv'))
        end
      end
    end
  end
end
