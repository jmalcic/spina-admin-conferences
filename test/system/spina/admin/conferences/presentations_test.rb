# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationsTest < ApplicationSystemTestCase
        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry
        end

        test 'visiting the index' do
          visit admin_conferences_presentations_path
          Percy.snapshot page, name: 'Presentations index'
        end

        test 'creating a presentation' do
          visit admin_conferences_presentations_path
          click_on 'New presentation'
          assert_current_path new_admin_conferences_presentation_path
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.session.name, from: 'presentation_session_id'
          fill_in 'presentation_start_datetime', with: @presentation.start_datetime
          fill_in 'presentation_title', with: @presentation.title
          fill_in_rich_text_area 'presentation[abstract]', with: @presentation.abstract
          @presentation.presenters.each { |presenter| check presenter.reversed_name_and_institution, allow_label_click: true }
          within '.presentation_attachment' do
            click_link class: %w[button button-link icon]
            within '#structure_form_pane_0' do
              select @presentation.attachments.first.name, from: 'presentation_attachments_attributes_0_attachment_type_id'
              select @presentation.attachments.first.attachment.name, from: 'presentation_attachments_attributes_0_attachment_id'
            end
          end
          Percy.snapshot page, name: 'Presentations form on create'
          click_on 'Save presentation'
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on create'
        end

        test 'updating a presentation' do
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_presentation_path(@presentation)
          Percy.snapshot page, name: 'Presentations form on update'
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.session.name, from: 'presentation_session_id'
          fill_in 'presentation_start_datetime', with: @presentation.start_datetime
          fill_in 'presentation_title', with: @presentation.title
          fill_in_rich_text_area 'presentation[abstract]', with: @presentation.abstract
          @presentation.presenters.each { |presenter| check presenter.reversed_name_and_institution, allow_label_click: true }
          within '.presentation_attachment' do
            click_link class: %w[button button-link icon]
            find_link(href: '#structure_form_pane_2').click
            within '#structure_form_pane_2' do
              select @presentation.attachments.second.name, from: 'presentation_attachments_attributes_2_attachment_type_id'
              select @presentation.attachments.first.attachment.name, from: 'presentation_attachments_attributes_2_attachment_id'
            end
          end
          click_on 'Save presentation'
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on update'
        end

        test 'updating a presentation in a locale' do
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_presentation_path(@presentation)
          click_link 'British English'
          click_link 'English'
          assert_current_path edit_admin_conferences_presentation_path(@presentation, locale: :en)
          Percy.snapshot page, name: 'Presentations form on update in locale'
          select @presentation.conference.name, from: 'conference_id'
          select @presentation.presentation_type.name, from: 'presentation_type_id'
          select @presentation.session.name, from: 'presentation_session_id'
          fill_in 'presentation_start_datetime', with: @presentation.start_datetime
          fill_in 'presentation_title', with: @presentation.title
          fill_in_rich_text_area 'presentation[abstract]', with: @presentation.abstract
          @presentation.presenters.each { |presenter| check presenter.reversed_name_and_institution, allow_label_click: true }
          within '.presentation_attachment' do
            click_link class: %w[button button-link icon]
            find_link(href: '#structure_form_pane_2').click
            within '#structure_form_pane_2' do
              select @presentation.attachments.second.name, from: 'presentation_attachments_attributes_2_attachment_type_id'
              select @presentation.attachments.first.attachment.name, from: 'presentation_attachments_attributes_2_attachment_id'
            end
          end
          click_on 'Save presentation'
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on update in locale'
        end

        test 'destroying a presentation' do
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_current_path edit_admin_conferences_presentation_path(@presentation)
          accept_confirm "Are you sure you want to delete the presentation <strong>#{@presentation.name}</strong>?" do
            click_on 'Permanently delete'
            Percy.snapshot page, name: 'Presentations delete dialog'
          end
          assert_current_path admin_conferences_presentations_path
          assert_text 'Presentation deleted'
          assert_no_selector "tr[data-presentation-id=\"#{@presentation.id}\"]"
          Percy.snapshot page, name: 'Presentations index on delete'
        end
      end
    end
  end
end
