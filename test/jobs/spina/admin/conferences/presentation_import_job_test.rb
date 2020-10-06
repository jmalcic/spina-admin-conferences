# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationImportJobTest < ActiveJob::TestCase
        setup do
          file_fixture('presentations.csv.erb').read
            .then { |file| ERB.new(file).result(binding) }
            .then { |result| Pathname.new(File.join(file_fixture_path, 'presentations.csv')).write(result) }
        end

        test 'job changes number of presentations' do
          assert_difference 'Presentation.count', 2 do
            PresentationImportJob.perform_now file_fixture('presentations.csv').open
          end
        end

        test 'presentation import scheduling' do
          assert_enqueued_with job: PresentationImportJob do
            Presentation.import file_fixture('presentations.csv').open
          end
        end

        test 'presentation import performing' do
          assert_performed_with job: PresentationImportJob do
            Presentation.import file_fixture('presentations.csv').open
          end
        end
      end
    end
  end
end
