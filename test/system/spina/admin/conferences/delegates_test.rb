# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class DelegatesTest < ApplicationSystemTestCase
        setup do
          @delegate = spina_conferences_delegates :joe_bloggs
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_delegates_url
          assert_selector '.breadcrumbs', text: 'Delegates'
        end

        test 'creating a delegate' do
          visit admin_conferences_delegates_url
          click_on 'New delegate'
          fill_in 'delegate_first_name', with: @delegate.first_name
          fill_in 'delegate_last_name', with: @delegate.last_name
          select @delegate.institution.name, from: 'delegate_institution_id'
          fill_in 'delegate_email_address', with: @delegate.email_address
          fill_in 'delegate_url', with: @delegate.url
          @delegate.conferences.each { |conference| select conference.name, from: 'delegate_conference_ids' }
          click_on 'Save delegate'
          assert_text 'Delegate saved'
        end

        test 'updating a delegate' do
          visit admin_conferences_delegates_url
          within "tr[data-delegate-id=\"#{@delegate.id}\"]" do
            click_on('Edit')
          end
          fill_in 'delegate_first_name', with: @delegate.first_name
          fill_in 'delegate_last_name', with: @delegate.last_name
          select @delegate.institution.name, from: 'delegate_institution_id'
          fill_in 'delegate_email_address', with: @delegate.email_address
          fill_in 'delegate_url', with: @delegate.url
          @delegate.conferences.each { |conference| select conference.name, from: 'delegate_conference_ids' }
          click_on 'Save delegate'
          assert_text 'Delegate saved'
        end

        test 'destroying a delegate' do
          visit admin_conferences_delegates_url
          within "tr[data-delegate-id=\"#{@delegate.id}\"]" do
            click_on('Edit')
          end
          click_on 'Permanently delete'
          click_on 'Yes, I\'m sure'
          assert_no_selector "tr[data-delegate-id=\"#{@delegate.id}\"]"
        end
      end
    end
  end
end
