# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationTypesTest < ApplicationSystemTestCase
        setup do
          @presentation_type = spina_admin_conferences_presentation_types :plenary_1
          @empty_presentation_type = spina_admin_conferences_presentation_types :empty_presentation_type
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_presentation_types_path
          assert_selector '.breadcrumbs' do
            assert_text 'Presentation types'
          end
          Percy.snapshot page, name: 'Presentation types index'
        end

        test 'creating a presentation type' do
          visit admin_conferences_presentation_types_path
          click_on 'New presentation type'
          assert_selector '.breadcrumbs' do
            assert_text 'New presentation type'
          end
          select @presentation_type.conference.name, from: 'presentation_type_conference_id'
          fill_in 'presentation_type_name', with: @presentation_type.name
          fill_in 'presentation_type_minutes', with: @presentation_type.minutes
          Percy.snapshot page, name: 'Presentation types form on create'
          click_on 'Save presentation type'
          assert_text 'Presentation type saved'
          Percy.snapshot page, name: 'Presentation types index on create'
        end

        test 'updating a presentation type' do
          visit admin_conferences_presentation_types_path
          within "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @presentation_type.name
          end
          Percy.snapshot page, name: 'Presentation types form on update'
          select @presentation_type.conference.name, from: 'presentation_type_conference_id'
          fill_in 'presentation_type_name', with: @presentation_type.name
          fill_in 'presentation_type_minutes', with: @presentation_type.minutes
          click_on 'Save presentation type'
          assert_text 'Presentation type saved'
          Percy.snapshot page, name: 'Presentation types index on update'
        end

        test 'destroying a presentation type' do
          visit admin_conferences_presentation_types_path
          within "tr[data-presentation-type-id=\"#{@empty_presentation_type.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @empty_presentation_type.name
          end
          accept_confirm "Are you sure you want to delete the presentation type <strong>#{@empty_presentation_type.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Presentation types delete dialog'
          end
          assert_text 'Presentation type deleted'
          assert_no_selector "tr[data-presentation-type-id=\"#{@empty_presentation_type.id}\"]"
          Percy.snapshot page, name: 'Presentation types index on delete'
        end
      end
    end
  end
end
