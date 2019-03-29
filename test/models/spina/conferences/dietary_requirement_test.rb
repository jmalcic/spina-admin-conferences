# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class DietaryRequirementTest < ActiveSupport::TestCase
      setup { @room = spina_conferences_dietary_requirements :pescetarian }

      test 'dietary requirement attributes must not be empty' do
        dietary_requirement = DietaryRequirement.new
        assert dietary_requirement.invalid?
        assert dietary_requirement.errors[:name].any?
      end
    end
  end
end
