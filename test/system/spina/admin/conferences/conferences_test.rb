# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class ConferencesTest < ApplicationSystemTestCase
        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017
          @user = spina_users :joe
          visit admin_login_path
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_conferences_path
          assert_selector '.breadcrumbs', text: 'Conferences'
          Percy.snapshot page, name: 'Conferences index'
        end

        test 'creating a conference' do
          visit admin_conferences_conferences_path
          click_on 'New conference'
          assert_selector '.breadcrumbs', text: 'New conference'
          select @conference.institution_name, from: 'admin_conferences_conference_institution_id'
          @conference.rooms.each { |room| select room.name, from: 'admin_conferences_conference_room_ids' }
          fill_in 'admin_conferences_conference_start_date', with: @conference.start_date
          fill_in 'admin_conferences_conference_finish_date', with: @conference.finish_date
          Percy.snapshot page, name: 'Conferences form on create'
          click_on 'Save conference'
          assert_text 'Conference saved'
          Percy.snapshot page, name: 'Conferences index on create'
        end

        test 'updating a conference' do
          visit admin_conferences_conferences_path
          within "tr[data-conference-id=\"#{@conference.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @conference.name
          Percy.snapshot page, name: 'Conferences form on update'
          select @conference.institution_name, from: 'admin_conferences_conference_institution_id'
          @conference.rooms.each { |room| select room.name, from: 'admin_conferences_conference_room_ids' }
          fill_in 'admin_conferences_conference_start_date', with: @conference.start_date
          fill_in 'admin_conferences_conference_finish_date', with: @conference.finish_date
          click_on 'Save conference'
          assert_text 'Conference saved'
          Percy.snapshot page, name: 'Conferences index on update'
        end

        test 'destroying a conference' do
          visit admin_conferences_conferences_path
          within "tr[data-conference-id=\"#{@conference.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @conference.name
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the conference #{@conference.name}?"
          Percy.snapshot page, name: 'Conferences delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Conference deleted'
          assert_no_selector "tr[data-conference-id=\"#{@conference.id}\"]"
          Percy.snapshot page, name: 'Conferences index on delete'
        end
      end
    end
  end
end
