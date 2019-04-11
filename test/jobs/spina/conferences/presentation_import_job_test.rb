# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PresentationImportJobTest < ActiveJob::TestCase
      include ::Spina::Conferences

      test 'that number of presentations changes' do
        assert_difference 'Presentation.count', 2 do
          PresentationImportJob.perform_now File.open(file_fixture('presentations.csv'))
        end
      end

      test 'presentation import scheduling' do
        assert_enqueued_with job: PresentationImportJob do
          Presentation.import File.open(file_fixture('presentations.csv'))
        end
      end

      test 'presentation import performing' do
        assert_performed_with job: PresentationImportJob do
          Presentation.import File.open(file_fixture('presentations.csv'))
        end
      end
    end
  end
end
