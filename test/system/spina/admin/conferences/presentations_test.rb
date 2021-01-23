# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationsTest < ApplicationSystemTestCase # rubocop:disable Metrics/ClassLength
        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_presentations_path
          assert_selector '.breadcrumbs' do
            assert_text 'Presentations'
          end
          Percy.snapshot page, name: 'Presentations index'
        end

        test 'creating a presentation' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_presentations_path
          click_on 'New presentation'
          assert_selector '.breadcrumbs' do
            assert_text 'New presentation'
          end
          select @presentation.conference.name, from: 'admin_conferences_conference_id'
          select @presentation.presentation_type.name, from: 'admin_conferences_presentation_type_id'
          select @presentation.session.name, from: 'admin_conferences_presentation_session_id'
          select I18n.localize(@presentation.date, locale: :'en-GB', format: :short),
                 from: 'admin_conferences_presentation_date'
          fill_in 'admin_conferences_presentation_start_time', with: @presentation.start_time
          fill_in 'admin_conferences_presentation_title', with: @presentation.title
          find(class: 'horizontal-form-label', text: 'Abstract')
            .sibling(class: 'horizontal-form-content').find('trix-editor')
            .execute_script('this.editor.loadHTML(arguments[0])', @presentation.abstract)
          @presentation.presenters.each do |presenter|
            select presenter.reversed_name_and_institution, from: 'admin_conferences_presentation_presenter_ids'
          end
          within '.admin_conferences_presentation_attachment' do
            click_link class: %w[button button-link icon]
            within '#structure_form_pane_0' do
              select @presentation.attachments.first.name,
                     from: 'admin_conferences_presentation_attachments_attributes_0_attachment_type_id'
              click_on 'Choose from library'
            end
          end
          within '#overlay', visible: true, style: { display: 'block' } do
            first('li').choose allow_label_click: true
            click_on 'Insert document'
          end
          assert_no_selector '#overlay'
          Percy.snapshot page, name: 'Presentations form on create'
          click_on 'Save presentation'
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on create'
        end

        test 'updating a presentation' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @presentation.name
          end
          Percy.snapshot page, name: 'Presentations form on update'
          select @presentation.conference.name, from: 'admin_conferences_conference_id'
          select @presentation.presentation_type.name, from: 'admin_conferences_presentation_type_id'
          select @presentation.session.name, from: 'admin_conferences_presentation_session_id'
          select I18n.localize(@presentation.date, locale: :'en-GB', format: :short),
                 from: 'admin_conferences_presentation_date'
          fill_in 'admin_conferences_presentation_start_time', with: @presentation.start_time
          fill_in 'admin_conferences_presentation_title', with: @presentation.title
          find(class: 'horizontal-form-label', text: 'Abstract')
            .sibling(class: 'horizontal-form-content').find('trix-editor')
            .execute_script('this.editor.loadHTML(arguments[0])', @presentation.abstract)
          @presentation.presenters.each do |presenter|
            select presenter.reversed_name_and_institution, from: 'admin_conferences_presentation_presenter_ids'
          end
          within '.admin_conferences_presentation_attachment' do
            click_link class: %w[button button-link icon]
            find_link(href: '#structure_form_pane_2').click
            within '#structure_form_pane_2' do
              select @presentation.attachments.second.name,
                     from: 'admin_conferences_presentation_attachments_attributes_2_attachment_type_id'
              click_on 'Choose from library'
            end
          end
          within '#overlay', visible: true, style: { display: 'block' } do
            first('li').choose allow_label_click: true
            click_on 'Insert document'
          end
          assert_no_selector '#overlay'
          click_on 'Save presentation'
          assert_text 'Presentation saved'
          Percy.snapshot page, name: 'Presentations index on update'
        end

        test 'destroying a presentation' do
          visit admin_conferences_presentations_path
          within "tr[data-presentation-id=\"#{@presentation.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs' do
            assert_text @presentation.name
          end
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the presentation #{@presentation.name}?"
          Percy.snapshot page, name: 'Presentations delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Presentation deleted'
          assert_no_selector "tr[data-presentation-id=\"#{@presentation.id}\"]"
          Percy.snapshot page, name: 'Presentations index on delete'
        end
      end
    end
  end
end
