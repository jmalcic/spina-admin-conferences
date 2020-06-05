# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DietaryRequirementTest < ActiveSupport::TestCase
        setup { @dietary_requirement = spina_admin_conferences_dietary_requirements :pescetarian }

        test 'translates name' do
          @dietary_requirement.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @dietary_requirement.name
          @dietary_requirement.name = 'bar'
          assert_equal 'bar', @dietary_requirement.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @dietary_requirement.name
        end

        test 'dietary requirement attributes must not be empty' do
          dietary_requirement = DietaryRequirement.new
          assert dietary_requirement.invalid?
          assert dietary_requirement.errors[:name].any?
        end
      end
    end
  end
end