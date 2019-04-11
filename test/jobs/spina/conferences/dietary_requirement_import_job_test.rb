# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    # noinspection RubyClassModuleNamingConvention
    class DietaryRequirementImportJobTest < ActiveJob::TestCase
      include ::Spina::Conferences

      test 'that number of dietary requirements changes' do
        assert_difference 'DietaryRequirement.count', 3 do
          DietaryRequirementImportJob.perform_now File.open(file_fixture('dietary_requirements.csv'))
        end
      end

      test 'dietary requirement import scheduling' do
        assert_enqueued_with job: DietaryRequirementImportJob do
          DietaryRequirement.import File.open(file_fixture('dietary_requirements.csv'))
        end
      end

      test 'dietary requirement import performing' do
        assert_performed_with job: DietaryRequirementImportJob do
          DietaryRequirement.import File.open(file_fixture('dietary_requirements.csv'))
        end
      end
    end
  end
end
