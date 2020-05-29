# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationTypesTest < ApplicationSystemTestCase
        setup do
          @presentation_type = spina_admin_conferences_presentation_types :plenary_1
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_presentation_types_url
          assert_selector '.breadcrumbs', text: 'Presentation types'
          Percy.snapshot page, name: 'Presentation types index'
        end

        test 'creating a presentation type' do
          visit admin_conferences_presentation_types_url
          click_on 'New presentation type'
          assert_selector '.breadcrumbs', text: 'New presentation type'
          select @presentation_type.conference.name, from: 'admin_conferences_presentation_type_conference_id'
          @presentation_type.room_possessions.each do |room_possession|
            select room_possession.room_name, from: 'admin_conferences_presentation_type_room_possession_ids'
          end
          fill_in 'admin_conferences_presentation_type_name', with: @presentation_type.name
          fill_in 'admin_conferences_presentation_type_minutes', with: @presentation_type.minutes
          Percy.snapshot page, name: 'Presentation types form on create'
          click_on 'Save presentation type'
          assert_text 'Presentation type saved'
          Percy.snapshot page, name: 'Presentation types index on create'
        end

        test 'updating a presentation type' do
          visit admin_conferences_presentation_types_url
          within "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @presentation_type.name
          Percy.snapshot page, name: 'Presentation types form on update'
          select @presentation_type.conference.name, from: 'admin_conferences_presentation_type_conference_id'
          @presentation_type.room_possessions.each do |room_possession|
            select room_possession.room_name, from: 'admin_conferences_presentation_type_room_possession_ids'
          end
          fill_in 'admin_conferences_presentation_type_name', with: @presentation_type.name
          fill_in 'admin_conferences_presentation_type_minutes', with: @presentation_type.minutes
          click_on 'Save presentation type'
          assert_text 'Presentation type saved'
          Percy.snapshot page, name: 'Presentation types index on update'
        end

        test 'destroying a presentation type' do
          visit admin_conferences_presentation_types_url
          within "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @presentation_type.name
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the presentation type #{@presentation_type.name}?"
          Percy.snapshot page, name: 'Presentation types delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Presentation type deleted'
          assert_no_selector "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]"
          Percy.snapshot page, name: 'Presentation types index on delete'
        end
      end
    end
  end
end
