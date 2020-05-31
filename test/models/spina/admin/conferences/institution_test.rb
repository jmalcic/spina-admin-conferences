# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionTest < ActiveSupport::TestCase
        setup { @institution = spina_admin_conferences_institutions :university_of_atlantis }

        test 'translates name' do
          @institution.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @institution.name
          @institution.name = 'bar'
          assert_equal 'bar', @institution.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @institution.name
        end

        test 'translates city' do
          @institution.city = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @institution.city
          @institution.city = 'bar'
          assert_equal 'bar', @institution.city
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @institution.city
        end

        test 'institution attributes must not be empty' do
          institution = Institution.new
          assert institution.invalid?
          assert institution.errors[:name].any?
          assert institution.errors[:city].any?
        end
      end
    end
  end
end
