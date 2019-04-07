# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationTypeImportJobTest < ActiveJob::TestCase
        include ::Spina::Conferences

        test 'that number of presentation types changes' do
          assert_difference 'PresentationType.count', 6 do
            PresentationTypeImportJob.perform_now File.open(file_fixture('presentation_types.csv'))
          end
        end

        test 'that number of room uses changes' do
          assert_difference 'RoomUse.count', 8 do
            PresentationTypeImportJob.perform_now File.open(file_fixture('presentation_types.csv'))
          end
        end

        test 'presentation type scheduling' do
          assert_enqueued_with job: PresentationTypeImportJob do
            PresentationType.import File.open(file_fixture('presentation_types.csv'))
          end
        end

        test 'presentation type performing' do
          assert_performed_with job: PresentationTypeImportJob do
            PresentationType.import File.open(file_fixture('presentation_types.csv'))
          end
        end
      end
    end
  end
end
