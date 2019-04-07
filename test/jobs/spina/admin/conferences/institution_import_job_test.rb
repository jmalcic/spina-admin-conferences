# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionImportJobTest < ActiveJob::TestCase
        include ::Spina::Conferences

        test 'that number of institutions changes' do
          assert_difference 'Institution.count', 2 do
            InstitutionImportJob.perform_now File.open(file_fixture('institutions.csv'))
          end
        end

        test 'that number of rooms changes' do
          assert_difference 'Room.count', 6 do
            InstitutionImportJob.perform_now File.open(file_fixture('institutions.csv'))
          end
        end

        test 'institution import scheduling' do
          assert_enqueued_with job: InstitutionImportJob do
            Institution.import File.open(file_fixture('institutions.csv'))
          end
        end

        test 'institution import performing' do
          assert_performed_with job: InstitutionImportJob do
            Institution.import File.open(file_fixture('institutions.csv'))
          end
        end
      end
    end
  end
end
