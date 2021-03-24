# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class InstitutionsTest < ApplicationSystemTestCase
        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @empty_institution = spina_admin_conferences_institutions :empty_institution
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_institutions_path
          assert_selector '.breadcrumbs' do
            assert_text 'Institutions'
          end
          Percy.snapshot page, name: 'Institutions index'
        end

        test 'creating an institution' do
          visit admin_conferences_institutions_path
          click_on 'New institution'
          assert_selector '.breadcrumbs' do
            assert_text 'New institution'
          end
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          Percy.snapshot page, name: 'Institutions form on create'
          click_on 'Save institution'
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on create'
        end

        test 'updating an institution' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @institution.name
          end
          Percy.snapshot page, name: 'Institutions form on update'
          fill_in 'institution_name', with: @institution.name
          fill_in 'institution_city', with: @institution.city
          click_on 'Choose image'
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          click_on 'Save institution'
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on update'
        end

        test 'destroying an institution' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@empty_institution.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @empty_institution.name
          end
          accept_confirm "Are you sure you want to delete the institution <strong>#{@empty_institution.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Institutions delete dialog'
          end
          assert_text 'Institution deleted'
          assert_no_selector "tr[data-institution-id=\"#{@empty_institution.id}\"]"
          Percy.snapshot page, name: 'Institutions index on delete'
        end
      end
    end
  end
end
