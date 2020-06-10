# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegateImportJobTest < ActiveJob::TestCase
        test 'job changes number of delegates' do
          assert_difference 'Delegate.count', 2 do
            DelegateImportJob.perform_now file_fixture('delegates.csv').open
          end
        end

        test 'delegate import scheduling' do
          assert_enqueued_with job: DelegateImportJob do
            Delegate.import file_fixture('delegates.csv').open
          end
        end

        test 'delegate import performing' do
          assert_performed_with job: DelegateImportJob do
            Delegate.import file_fixture('delegates.csv').open
          end
        end
      end
    end
  end
end
