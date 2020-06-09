# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class InstitutionsTest < ApplicationSystemTestCase
        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @empty_institution = spina_admin_conferences_institutions :empty_institution
          @user = spina_users :joe
          visit admin_login_path
          within '.login-fields' do
            fill_in 'email', with: @user.email
            fill_in 'password', with: 'password'
          end
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_institutions_path
          assert_selector '.breadcrumbs', text: 'Institutions'
          Percy.snapshot page, name: 'Institutions index'
        end

        test 'creating an institution' do # rubocop:disable Metrics/BlockLength
          visit admin_conferences_institutions_path
          click_on 'New institution'
          assert_selector '.breadcrumbs', text: 'New institution'
          fill_in 'admin_conferences_institution_name', with: @institution.name
          fill_in 'admin_conferences_institution_city', with: @institution.city
          execute_script '$.fx.off = true;'
          click_on 'Choose image'
          within '#overlay', visible: true, style: { display: 'block' } do
            attach_file(file_fixture('dubrovnik.jpeg')) do
              input = find 'input[type="file"][data-customfileinput]', visible: false
              execute_script(<<~JS, input)
                arguments[0].dispatchEvent(
                  new MouseEvent('click', {
                    view: window,
                    bubbles: true,
                    cancelable: true
                  })
                );
              JS
            end
            first('.gallery .item:not(.item-uploader)').click
            find('.gallery-select-sidebar').click_on 'Choose image'
          end
          assert_no_selector '#overlay'
          Percy.snapshot page, name: 'Institutions form on create'
          click_on 'Save institution'
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on create'
        end

        test 'updating an institution' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @institution.name
          Percy.snapshot page, name: 'Institutions form on update'
          fill_in 'admin_conferences_institution_name', with: @institution.name
          fill_in 'admin_conferences_institution_city', with: @institution.city
          page.execute_script '$.fx.off = true;'
          click_on 'Choose image'
          within '#overlay', visible: true, style: { display: 'block' } do
            attach_file(file_fixture('dubrovnik.jpeg')) do
              input = find 'input[type="file"][data-customfileinput]', visible: false
              execute_script(<<~JS, input)
                arguments[0].dispatchEvent(
                  new MouseEvent('click', {
                    view: window,
                    bubbles: true,
                    cancelable: true
                  })
                );
              JS
            end
            first('.gallery .item:not(.item-uploader)').click
            find('.gallery-select-sidebar').click_on 'Choose image'
          end
          assert_no_selector '#overlay'
          click_on 'Save institution'
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on update'
        end

        test 'destroying an institution' do
          visit admin_conferences_institutions_path
          within "tr[data-institution-id=\"#{@empty_institution.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @empty_institution.name
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the institution #{@empty_institution.name}?"
          Percy.snapshot page, name: 'Institutions delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Institution deleted'
          assert_no_selector "tr[data-institution-id=\"#{@empty_institution.id}\"]"
          Percy.snapshot page, name: 'Institutions index on delete'
        end
      end
    end
  end
end
