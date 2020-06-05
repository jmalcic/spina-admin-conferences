# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DietaryRequirementTest < ActiveSupport::TestCase
        setup do
          @dietary_requirement = spina_admin_conferences_dietary_requirements :pescetarian
          @new_dietary_requirement = DietaryRequirement.new
        end

        test 'translates name' do
          @dietary_requirement.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @dietary_requirement.name
          @dietary_requirement.name = 'bar'
          assert_equal 'bar', @dietary_requirement.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @dietary_requirement.name
        end

        test 'dietary have sorted scope' do
          assert_equal DietaryRequirement.i18n.order(:name), DietaryRequirement.sorted
        end

        test 'dietary requirement has associated delegates' do
          assert_not_empty @dietary_requirement.delegates
          assert_empty @new_dietary_requirement.delegates
        end

        test 'name must not be empty' do
          assert @dietary_requirement.valid?
          assert_empty @dietary_requirement.errors[:name]
          @dietary_requirement.name = nil
          assert @dietary_requirement.invalid?
          assert_not_empty @dietary_requirement.errors[:name]
        end
      end
    end
  end
end
