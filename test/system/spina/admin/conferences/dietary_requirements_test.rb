# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class DietaryRequirementsTest < ApplicationSystemTestCase
        setup do
          @dietary_requirement = spina_admin_conferences_dietary_requirements :vegan
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_dietary_requirements_path
          Percy.snapshot page, name: 'Dietary requirements index'
        end

        test 'creating a dietary requirement' do
          visit admin_conferences_dietary_requirements_path
          click_on 'New dietary requirement'
          assert_current_path new_admin_conferences_dietary_requirement_path
          fill_in 'dietary_requirement_name', with: @dietary_requirement.name
          Percy.snapshot page, name: 'Dietary requirements form on create'
          click_on 'Save dietary requirement'
          assert_current_path admin_conferences_dietary_requirements_path
          assert_text 'Dietary requirement saved'
          Percy.snapshot page, name: 'Dietary requirements index on create'
        end

        test 'updating a dietary requirement' do
          visit admin_conferences_dietary_requirements_path
          within "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_dietary_requirement_path(@dietary_requirement)
          Percy.snapshot page, name: 'Dietary requirements form on update'
          fill_in 'dietary_requirement_name', with: @dietary_requirement.name
          click_on 'Save dietary requirement'
          assert_current_path admin_conferences_dietary_requirements_path
          assert_text 'Dietary requirement saved'
          Percy.snapshot page, name: 'Dietary requirements index on update'
        end

        test 'updating a dietary requirement in a locale' do
          visit admin_conferences_dietary_requirements_path
          within "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_dietary_requirement_path(@dietary_requirement)
          click_link 'British English'
          click_link 'English'
          assert_current_path edit_admin_conferences_dietary_requirement_path(@dietary_requirement, locale: :en)
          Percy.snapshot page, name: 'Dietary requirements form on update in locale'
          fill_in 'dietary_requirement_name', with: @dietary_requirement.name
          click_on 'Save dietary requirement'
          assert_current_path admin_conferences_dietary_requirements_path
          assert_text 'Dietary requirement saved'
          Percy.snapshot page, name: 'Dietary requirements index on update in locale'
        end

        test 'destroying a dietary requirement' do
          visit admin_conferences_dietary_requirements_path
          within "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_dietary_requirement_path(@dietary_requirement)
          accept_confirm "Are you sure you want to delete the dietary requirement <strong>#{@dietary_requirement.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Dietary requirements delete dialog'
          end
          assert_current_path admin_conferences_dietary_requirements_path
          assert_text 'Dietary requirement deleted'
          assert_no_selector "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]"
          Percy.snapshot page, name: 'Dietary requirements index on delete'
        end
      end
    end
  end
end
