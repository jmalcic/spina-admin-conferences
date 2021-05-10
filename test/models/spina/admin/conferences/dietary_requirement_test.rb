# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DietaryRequirementTest < ActiveSupport::TestCase
        setup do
          @valid_dietary_requirement = spina_admin_conferences_dietary_requirements :valid_dietary_requirement
          @new_dietary_requirement = DietaryRequirement.new
        end

        test 'translates name' do
          @valid_dietary_requirement.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @valid_dietary_requirement.name
          @valid_dietary_requirement.name = 'bar'
          assert_equal 'bar', @valid_dietary_requirement.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @valid_dietary_requirement.name
        end

        test 'dietary have sorted scope' do
          assert_equal DietaryRequirement.i18n.order(:name), DietaryRequirement.sorted
        end

        test 'dietary requirement has associated delegates' do
          assert_not_empty @valid_dietary_requirement.delegates
          assert_empty @new_dietary_requirement.delegates
        end

        test 'name must not be empty' do
          assert @valid_dietary_requirement.valid?
          assert_empty @valid_dietary_requirement.errors[:name]
          @valid_dietary_requirement.name = nil
          assert @valid_dietary_requirement.invalid?
          assert_not_empty @valid_dietary_requirement.errors[:name]
        end
      end
    end
  end
end
