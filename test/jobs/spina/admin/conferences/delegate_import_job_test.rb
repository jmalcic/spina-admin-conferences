# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegateImportJobTest < ActiveJob::TestCase
        include ::Spina::Conferences

        test 'that number of delegates changes' do
          assert_difference 'Delegate.count', 2 do
            DelegateImportJob.perform_now File.open(file_fixture('delegates.csv'), filename: 'delegates.csv')
          end
        end

        test 'delegate import scheduling' do
          assert_enqueued_with job: DelegateImportJob do
            Delegate.import File.open(file_fixture('delegates.csv'), filename: 'delegates.csv')
          end
        end

        test 'delegate import performing' do
          assert_performed_with job: DelegateImportJob do
            Delegate.import File.open(file_fixture('delegates.csv'), filename: 'delegates.csv')
          end
        end
      end
    end
  end
end
