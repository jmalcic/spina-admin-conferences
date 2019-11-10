# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class ConferencesTest < ApplicationSystemTestCase
        include ::Spina::Engine.routes.url_helpers

        setup do
          @conference = spina_conferences_conferences :university_of_atlantis_2017
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_conferences_url
          assert_selector '.breadcrumbs', text: 'Conferences'
        end

        test 'creating a conference' do
          visit admin_conferences_conferences_url
          click_on 'New conference'
          select @conference.institution_name, from: 'conference_institution_id'
          fill_in 'conference_start_date', with: @conference.start_date
          fill_in 'conference_finish_date', with: @conference.finish_date
          @conference.rooms.each { |room| select room.name, from: 'conference_room_ids' }
          click_on 'Save conference'
          assert_text 'Conference saved'
        end

        test 'updating a conference' do
          visit admin_conferences_conferences_url
          within "tr[data-conference-id=\"#{@conference.id}\"]" do
            click_on 'Edit'
          end
          select @conference.institution_name, from: 'conference_institution_id'
          fill_in 'conference_start_date', with: @conference.start_date
          fill_in 'conference_finish_date', with: @conference.finish_date
          @conference.rooms.each { |room| select room.name, from: 'conference_room_ids' }
          click_on 'Save conference'
          assert_text 'Conference saved'
        end

        test 'destroying a conference' do
          visit admin_conferences_conferences_url
          within "tr[data-conference-id=\"#{@conference.id}\"]" do
            click_on 'Edit'
          end
          click_on 'Permanently delete'
          click_on 'Yes, I\'m sure'
          assert_no_selector "tr[data-conference-id=\"#{@conference.id}\"]"
        end
      end
    end
  end
end
