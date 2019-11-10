# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class DietaryRequirementsTest < ApplicationSystemTestCase
        include ::Spina::Engine.routes.url_helpers

        setup do
          @dietary_requirement = spina_conferences_dietary_requirements :vegan
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_dietary_requirements_url
          assert_selector '.breadcrumbs', text: 'Dietary requirements'
        end

        test 'creating a dietary requirement' do
          visit admin_conferences_dietary_requirements_url
          click_on 'New dietary requirement'
          fill_in 'dietary_requirement_name', with: @dietary_requirement.name
          click_on 'Save dietary requirement'
          assert_text 'Dietary requirement saved'
        end

        test 'updating a dietary requirement' do
          visit admin_conferences_dietary_requirements_url
          within "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]" do
            click_on('Edit')
          end
          fill_in 'dietary_requirement_name', with: @dietary_requirement.name
          click_on 'Save dietary requirement'
          assert_text 'Dietary requirement saved'
        end

        test 'destroying a dietary requirement' do
          visit admin_conferences_dietary_requirements_url
          within "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]" do
            click_on('Edit')
          end
          click_on 'Permanently delete'
          click_on 'Yes, I\'m sure'
          assert_no_selector "tr[data-dietary-requirement-id=\"#{@dietary_requirement.id}\"]"
        end
      end
    end
  end
end
