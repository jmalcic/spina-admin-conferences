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
          assert_selector '.breadcrumbs', text: 'Conferences'
          Percy.snapshot page, name: 'Conferences index'
        end

        test 'creating a conference' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_conferences_path
          click_on 'New conference'
          assert_selector '.breadcrumbs', text: 'New conference'
          fill_in 'admin_conferences_conference_name', with: @conference.name
          fill_in 'admin_conferences_conference_start_date', with: @conference.start_date
          fill_in 'admin_conferences_conference_finish_date', with: @conference.finish_date
          within '.admin_conferences_event' do
            click_link class: %w[button button-link icon]
            within '#structure_form_pane_0' do
              fill_in 'admin_conferences_conference_events_attributes_0_name', with: @conference.events.first.name
              fill_in 'admin_conferences_conference_events_attributes_0_date', with: @conference.events.first.date
              fill_in 'admin_conferences_conference_events_attributes_0_start_time', with: @conference.events.first.start_time
              fill_in 'admin_conferences_conference_events_attributes_0_finish_time', with: @conference.events.first.finish_time
              fill_in 'admin_conferences_conference_events_attributes_0_location', with: @conference.events.first.location
              find(class: 'horizontal-form-label', text: 'Description')
                .sibling(class: 'horizontal-form-content').find('trix-editor')
                .execute_script('this.editor.loadHTML(arguments[0])', @conference.events.first.description)
            end
          end
          Percy.snapshot page, name: 'Conferences form on create'
          click_on 'Parts'
          within '[data-name="text"]' do
            find('trix-editor')
              .execute_script('this.editor.loadHTML(arguments[0])', @conference.parts.find_by(name: 'text').partable.content)
          end
          within '[data-name="submission_url"]' do
            fill_in with: @conference.parts.find_by(name: 'submission_url').partable.content
          end
          within '[data-name="submission_date"]' do
            fill_in with: @conference.parts.find_by(name: 'submission_date').partable.content
          end
          within '[data-name="submission_text"]' do
            fill_in with: @conference.parts.find_by(name: 'submission_text').partable.content
          end
          within '[data-name="gallery"]' do
            execute_script '$.fx.off = true;'
            click_on 'Choose image'
          end
          within '#overlay', visible: true, style: { display: 'block' } do
            first('.gallery .item:not(.item-uploader)').click
            find('.gallery-select-sidebar').click_on 'Choose image'
          end
          assert_no_selector '#overlay'
          within '[data-name="sponsors"]' do
            click_link class: %w[button button-link]
            within id: /structure_form_pane_[0-9]+/ do
              fill_in id: /admin_conferences_conference_parts_attributes_5_partable_attributes_structure_items_attributes_[0-9]+
                           _structure_parts_attributes_0_partable_attributes_content/x,
                      with: @conference.parts.find_by(name: 'sponsors').partable.structure_items.first.structure_parts.find_by(name: 'name')
                                       .partable.content
              fill_in id: /admin_conferences_conference_parts_attributes_5_partable_attributes_structure_items_attributes_[0-9]+
                           _structure_parts_attributes_2_partable_attributes_content/x,
                      with: @conference.parts.find_by(name: 'sponsors').partable.structure_items.first.structure_parts
                                       .find_by(name: 'website').partable.content
              execute_script '$.fx.off = true;'
              click_on 'Choose image'
            end
          end
          within '#overlay', visible: true, style: { display: 'block' } do
            first('.gallery .item:not(.item-uploader)').click
            find('.gallery-select-sidebar').click_on 'Choose image'
          end
          assert_no_selector '#overlay'
          click_on 'Save conference'
          assert_text 'Conference saved'
          Percy.snapshot page, name: 'Conferences index on create'
        end

        test 'updating a conference' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_conferences_path
          within "tr[data-conference-id=\"#{@conference.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @conference.name
          Percy.snapshot page, name: 'Conferences form on update'
          fill_in 'admin_conferences_conference_name', with: @conference.name
          fill_in 'admin_conferences_conference_start_date', with: @conference.start_date
          fill_in 'admin_conferences_conference_finish_date', with: @conference.finish_date
          within '.admin_conferences_event' do
            click_link class: %w[button button-link icon]
            within '.structure-form-menu ul' do
              click_link href: '#structure_form_pane_1'
            end
            within '#structure_form_pane_1' do
              fill_in 'admin_conferences_conference_events_attributes_1_name', with: @conference.events.first.name
              fill_in 'admin_conferences_conference_events_attributes_1_date', with: @conference.events.first.date
              fill_in 'admin_conferences_conference_events_attributes_1_start_time', with: @conference.events.first.start_time
              fill_in 'admin_conferences_conference_events_attributes_1_finish_time', with: @conference.events.first.finish_time
              fill_in 'admin_conferences_conference_events_attributes_1_location', with: @conference.events.first.location
              find(class: 'horizontal-form-label', text: 'Description')
                .sibling(class: 'horizontal-form-content').find('trix-editor')
                .execute_script('this.editor.loadHTML(arguments[0])', @conference.events.first.description)
            end
          end
          click_on 'Parts'
          within '[data-name="text"]' do
            find('trix-editor')
              .execute_script('this.editor.loadHTML(arguments[0])', @conference.parts.find_by(name: 'text').partable.content)
          end
          within '[data-name="submission_url"]' do
            fill_in with: @conference.parts.find_by(name: 'submission_url').partable.content
          end
          within '[data-name="submission_date"]' do
            fill_in with: @conference.parts.find_by(name: 'submission_date').partable.content
          end
          within '[data-name="submission_text"]' do
            fill_in with: @conference.parts.find_by(name: 'submission_text').partable.content
          end
          within '[data-name="gallery"]' do
            execute_script '$.fx.off = true;'
            click_on 'Choose image'
          end
          within '#overlay', visible: true, style: { display: 'block' } do
            first('.gallery .item:not(.item-uploader)').click
            find('.gallery-select-sidebar').click_on 'Choose image'
          end
          assert_no_selector '#overlay'
          within '[data-name="sponsors"]' do
            within id: /structure_form_pane_[0-9]+/ do
              fill_in id: /admin_conferences_conference_parts_attributes_5_partable_attributes_structure_items_attributes_[0-9]+
                             _structure_parts_attributes_0_partable_attributes_content/x,
                      with: @conference.parts.find_by(name: 'sponsors').partable.structure_items.first.structure_parts.find_by(name: 'name')
                                       .partable.content
              fill_in id: /admin_conferences_conference_parts_attributes_5_partable_attributes_structure_items_attributes_[0-9]+
                             _structure_parts_attributes_2_partable_attributes_content/x,
                      with: @conference.parts.find_by(name: 'sponsors').partable.structure_items.first.structure_parts
                                       .find_by(name: 'website').partable.content
              execute_script '$.fx.off = true;'
              click_on 'Choose image'
            end
          end
          within '#overlay', visible: true, style: { display: 'block' } do
            first('.gallery .item:not(.item-uploader)').click
            find('.gallery-select-sidebar').click_on 'Choose image'
          end
          assert_no_selector '#overlay'
          click_on 'Save conference'
          assert_text 'Conference saved'
          Percy.snapshot page, name: 'Conferences index on update'
        end

        test 'destroying a conference' do
          visit admin_conferences_conferences_path
          within "tr[data-conference-id=\"#{@empty_conference.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @empty_conference.name
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the conference #{@empty_conference.name}?"
          Percy.snapshot page, name: 'Conferences delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Conference deleted'
          assert_no_selector "tr[data-conference-id=\"#{@empty_conference.id}\"]"
          Percy.snapshot page, name: 'Conferences index on delete'
        end
      end
    end
  end
end
