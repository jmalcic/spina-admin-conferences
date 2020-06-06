# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionTest < ActiveSupport::TestCase
        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @new_institution = Institution.new
        end

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

        test 'institutions have sorted scope' do
          assert_equal Institution.i18n.order(:name), Institution.sorted
        end

        test 'institution has associated rooms' do
          assert_not_empty @institution.rooms
          assert_empty @new_institution.rooms
        end

        test 'institution has associated delegates' do
          assert_not_empty @institution.delegates
          assert_empty @new_institution.delegates
        end

        test 'accepts nested attributes for rooms' do
          assert_changes '@institution.rooms.first.number' do
            @institution.assign_attributes(rooms_attributes: { id: @institution.rooms.first.id, number: 99 })
          end
        end

        test 'does not destroy associated rooms' do
          assert_no_difference 'Room.count' do
            @institution.destroy
          end
          assert_not_empty @institution.errors[:base]
        end

        test 'does not destroy associated delegates' do
          assert_no_difference 'Delegate.count' do
            @institution.destroy
          end
          assert_not_empty @institution.errors[:base]
        end

        test 'logo may be empty' do
          assert @institution.valid?
          assert_empty @institution.errors[:logo]
          @institution.logo = nil
          assert @institution.valid?
          assert_empty @institution.errors[:logo]
        end

        test 'name must not be empty' do
          assert @institution.valid?
          assert_empty @institution.errors[:name]
          @institution.name = nil
          assert @institution.invalid?
          assert_not_empty @institution.errors[:name]
        end

        test 'city must not be empty' do
          assert @institution.valid?
          assert_empty @institution.errors[:city]
          @institution.city = nil
          assert @institution.invalid?
          assert_not_empty @institution.errors[:city]
        end
      end
    end
  end
end
