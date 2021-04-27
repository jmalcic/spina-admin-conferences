# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class InstitutionsTest < ApplicationSystemTestCase
        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @empty_institution = spina_admin_conferences_institutions :empty_institution
        end

        test 'visiting the index' do
          visit admin_conferences_institutions_path
          Percy.snapshot page, name: 'Institutions index'
        end

        test 'creating an institution' do
          visit admin_conferences_institutions_path
          click_on 'New institution'
          assert_current_path new_admin_conferences_institution_path
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          Percy.snapshot page, name: 'Institutions form on create'
          click_on 'Save institution'
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on create'
        end

        test 'updating an institution' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_institution_path(@institution)
          Percy.snapshot page, name: 'Institutions form on update'
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          click_on 'Save institution'
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on update'
        end

        test 'updating an institution in a locale' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_institution_path(@institution)
          click_link 'British English'
          click_link 'English'
          assert_current_path edit_admin_conferences_institution_path(@institution, locale: :en)
          Percy.snapshot page, name: 'Institutions form on update in locale'
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          click_on 'Save institution'
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on update in locale'
        end

        test 'destroying an institution' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@empty_institution.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_institution_path(@empty_institution)
          accept_confirm "Are you sure you want to delete the institution <strong>#{@empty_institution.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Institutions delete dialog'
          end
          assert_current_path admin_conferences_institutions_path
          assert_text 'Institution deleted'
          assert_no_selector "tr[data-institution-id=\"#{@empty_institution.id}\"]"
          Percy.snapshot page, name: 'Institutions index on delete'
        end
      end
    end
  end
end
