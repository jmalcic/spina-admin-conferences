# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class ConferencesTest < ApplicationSystemTestCase # rubocop:disable Metrics/ClassLength
        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017
          @empty_conference = spina_admin_conferences_conferences :empty_conference
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_conferences_path
          assert_selector '.breadcrumbs' do
            assert_text 'Conferences'
          end
          Percy.snapshot page, name: 'Conferences index'
        end

        test 'creating a conference' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_conferences_path
          click_on 'New conference'
          assert_selector '.breadcrumbs' do
            assert_text 'New conference'
          end
          fill_in 'conference_name', with: @conference.name
          fill_in 'conference_start_date', with: @conference.start_date
          fill_in 'conference_finish_date', with: @conference.finish_date
          within '.event' do
            click_link class: %w[button button-link icon]
            within '#structure_form_pane_0' do
              fill_in id: /conference_events_attributes_[0-9]_name/, with: @conference.events.first.name
              fill_in id: /conference_events_attributes_[0-9]_start_datetime/, with: @conference.events.first.start_datetime
              fill_in id: /conference_events_attributes_[0-9]_finish_datetime/, with: @conference.events.first.finish_datetime
              fill_in id: /conference_events_attributes_[0-9]_location/, with: @conference.events.first.location
              fill_in_rich_text_area with: @conference.events.first.description
            end
          end
          Percy.snapshot page, name: 'Conferences form on create'
          click_on 'Parts'
          within '[data-name="text"]' do
            fill_in_rich_text_area with: @conference.content(:text)
          end
          within '[data-name="submission_url"]' do
            fill_in with: @conference.content(:submission_url)
          end
          within '[data-name="submission_email_address"]' do
            fill_in with: @conference.content(:submission_email_address)
          end
          within '[data-name="submission_date"]' do
            fill_in with: @conference.content(:submission_date)
          end
          within '[data-name="submission_text"]' do
            fill_in with: @conference.content(:submission_text)
          end
          within '[data-name="gallery"]' do
            first('.images .page-form-media-picker-placeholder').execute_script <<~JS
              this.style.position = 'static'
            JS
            click_on 'Choose'
          end
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
            click_on 'Confirm selection (1)'
          end
          within '[data-name="sponsors"]' do
            click_link class: %w[button button-link]
            within id: /structure_form_pane_[0-9]+/ do
              fill_in id: /conference_en-GB_content_attributes_[0-9]+_content_attributes_[0-9]+_parts_attributes_0_content/x,
                      with: @conference.content(:sponsors).first.content(:name)
              fill_in id: /conference_en-GB_content_attributes_[0-9]+_content_attributes_[0-9]+_parts_attributes_1_content/x,
                      with: @conference.content(:sponsors).first.content(:website)
              click_on 'Choose image'
            end
          end
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          click_on 'Save conference'
          assert_current_path admin_conferences_conferences_path
          assert_text 'Conference saved'
          Percy.snapshot page, name: 'Conferences index on create'
        end

        test 'updating a conference' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_conferences_path
          within "tr[data-conference-id=\"#{@conference.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @conference.name
          end
          Percy.snapshot page, name: 'Conferences form on update'
          fill_in 'conference_name', with: @conference.name
          fill_in 'conference_start_date', with: @conference.start_date
          fill_in 'conference_finish_date', with: @conference.finish_date
          within '.event' do
            click_link class: %w[button button-link icon]
            within '.structure-form-menu ul' do
              click_link href: '#structure_form_pane_1'
            end
            within '#structure_form_pane_1' do
              fill_in id: /conference_events_attributes_[0-9]_name/, with: @conference.events.first.name
              fill_in id: /conference_events_attributes_[0-9]_start_datetime/, with: @conference.events.first.start_datetime
              fill_in id: /conference_events_attributes_[0-9]_finish_datetime/, with: @conference.events.first.finish_datetime
              fill_in id: /conference_events_attributes_[0-9]_location/, with: @conference.events.first.location
              fill_in_rich_text_area with: @conference.events.first.description
            end
          end
          click_on 'Parts'
          within '[data-name="text"]' do
            fill_in_rich_text_area with: @conference.content(:text)
          end
          within '[data-name="submission_url"]' do
            fill_in with: @conference.content(:submission_url)
          end
          within '[data-name="submission_email_address"]' do
            fill_in with: @conference.content(:submission_email_address)
          end
          within '[data-name="submission_date"]' do
            fill_in with: @conference.content(:submission_date)
          end
          within '[data-name="submission_text"]' do
            fill_in with: @conference.content(:submission_text)
          end
          within '[data-name="gallery"]' do
            first('.images .page-form-media-picker-placeholder').execute_script <<~JS
              this.style.position = 'static'
            JS
            click_on 'Choose'
          end
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
            click_on 'Confirm selection (1)'
          end
          within '[data-name="sponsors"]' do
            within id: /structure_form_pane_[0-9]+/ do
              fill_in id: /conference_en-GB_content_attributes_[0-9]+_content_attributes_[0-9]+_parts_attributes_0_content/x,
                      with: @conference.content(:sponsors).first.content(:name)
              fill_in id: /conference_en-GB_content_attributes_[0-9]+_content_attributes_[0-9]+_parts_attributes_1_content/x,
                      with: @conference.content(:sponsors).first.content(:website)
              click_on 'Choose image'
            end
          end
          within '.modal', visible: true, style: { display: 'block' } do
            first('.media-picker-image').click
          end
          click_on 'Save conference'
          assert_current_path admin_conferences_conferences_path
          assert_text 'Conference saved'
          Percy.snapshot page, name: 'Conferences index on update'
        end

        test 'destroying a conference' do
          visit admin_conferences_conferences_path
          within "tr[data-conference-id=\"#{@empty_conference.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @empty_conference.name
          end
          accept_confirm "Are you sure you want to delete the conference <strong>#{@empty_conference.name}</strong>?" do
            click_on 'Permanently delete'
          end
          assert_current_path admin_conferences_conferences_path
          assert_text 'Conference deleted'
          assert_no_selector "tr[data-conference-id=\"#{@empty_conference.id}\"]"
          Percy.snapshot page, name: 'Conferences index on delete'
        end
      end
    end
  end
end
