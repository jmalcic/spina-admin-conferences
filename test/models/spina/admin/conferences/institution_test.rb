# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionTest < ActiveSupport::TestCase
        setup do
          @institution_without_dependents = spina_admin_conferences_institutions :institution_without_dependents
          @institution_with_logo = spina_admin_conferences_institutions :institution_with_logo
          @institution_with_rooms = spina_admin_conferences_institutions :institution_with_rooms
          @new_institution = Institution.new
        end

        test 'translates name' do
          @institution_without_dependents.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @institution_without_dependents.name
          @institution_without_dependents.name = 'bar'
          assert_equal 'bar', @institution_without_dependents.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @institution_without_dependents.name
        end

        test 'translates city' do
          @institution_without_dependents.city = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @institution_without_dependents.city
          @institution_without_dependents.city = 'bar'
          assert_equal 'bar', @institution_without_dependents.city
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @institution_without_dependents.city
        end

        test 'institutions have sorted scope' do
          assert_equal Institution.i18n.order(:name), Institution.sorted
        end

        test 'institution has associated logo' do
          assert_not_nil @institution_with_logo.logo
          assert_nil @new_institution.logo
        end

        test 'institution has associated rooms' do
          assert_not_empty @institution_with_rooms.rooms
          assert_empty @new_institution.rooms
        end

        test 'institution has associated delegates' do
          assert_not_empty @institution.delegates
          assert_empty @new_institution.delegates
        end

        test 'accepts nested attributes for rooms' do
          assert_changes '@institution_with_rooms.rooms.first.number' do
            @institution_with_rooms.assign_attributes(rooms_attributes: { id: @institution_with_rooms.rooms.first.id, number: 99 })
          end
        end

        test 'does not destroy associated rooms' do
          assert_no_difference 'Room.count' do
            @institution_with_rooms.destroy
          end
          assert_not_empty @institution_with_rooms.errors[:base]
        end

        test 'does not destroy associated delegates' do
          assert_no_difference 'Delegate.count' do
            @institution.destroy
          end
          assert_not_empty @institution.errors[:base]
        end

        test 'logo may be empty' do
          assert @institution_without_dependents.valid?
          assert_empty @institution_without_dependents.errors[:logo]
          @institution_without_dependents.logo = nil
          assert @institution_without_dependents.valid?
          assert_empty @institution_without_dependents.errors[:logo]
        end

        test 'name must not be empty' do
          assert @institution_without_dependents.valid?
          assert_empty @institution_without_dependents.errors[:name]
          @institution_without_dependents.name = nil
          assert @institution_without_dependents.invalid?
          assert_not_empty @institution_without_dependents.errors[:name]
        end

        test 'city must not be empty' do
          assert @institution_without_dependents.valid?
          assert_empty @institution_without_dependents.errors[:city]
          @institution_without_dependents.city = nil
          assert @institution_without_dependents.invalid?
          assert_not_empty @institution_without_dependents.errors[:city]
        end
      end
    end
  end
end
