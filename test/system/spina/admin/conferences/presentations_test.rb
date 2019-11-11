# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationsTest < ApplicationSystemTestCase
        setup do
          @presentation = spina_conferences_presentations :asymmetry_and_antisymmetry
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_presentations_url
          assert_selector '.breadcrumbs', text: 'Presentations'
        end

        test 'creating a presentation' do
          visit admin_conferences_presentations_url
          click_on 'New presentation'
          assert_selector '.horizontal-form[data-select-options-records-values]'
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.room_use.room_name, from: 'presentation_room_use_id'
          select I18n.localize(@presentation.date, locale: :'en-GB', format: :short), from: 'presentation_date'
          fill_in 'presentation_start_time', with: @presentation.start_time
          fill_in 'presentation_title', with: @presentation.title
          find(class: 'horizontal-form-label', text: 'Abstract')
            .sibling(class: 'horizontal-form-content').find('trix-editor')
            .execute_script('this.editor.loadHTML(arguments[0])', @presentation.abstract)
          @presentation.presenters.each do |presenter|
            select presenter.reversed_name_and_institution, from: 'presentation_presenter_ids'
          end
          click_on 'Save presentation'
          assert_text 'Presentation saved'
        end

        test 'updating a presentation' do
          visit admin_conferences_presentations_url
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on('Edit')
          end
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.room_use.room_name, from: 'presentation_room_use_id'
          select I18n.localize(@presentation.date, locale: :'en-GB', format: :short), from: 'presentation_date'
          fill_in 'presentation_start_time', with: @presentation.start_time
          fill_in 'presentation_title', with: @presentation.title
          find(class: 'horizontal-form-label', text: 'Abstract')
            .sibling(class: 'horizontal-form-content').find('trix-editor')
            .execute_script('this.editor.loadHTML(arguments[0])', @presentation.abstract)
          @presentation.presenters.each do |presenter|
            select presenter.reversed_name_and_institution, from: 'presentation_presenter_ids'
          end
          click_on 'Save presentation'
          assert_text 'Presentation saved'
        end

        test 'destroying a presentation' do
          visit admin_conferences_presentations_url
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on('Edit')
          end
          click_on 'Permanently delete'
          click_on 'Yes, I\'m sure'
          assert_no_selector "tr[data-presentation-id=\"#{@presentation.id}\"]"
        end
      end
    end
  end
end
