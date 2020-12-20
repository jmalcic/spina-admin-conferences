# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class AccountTest < ActiveSupport::TestCase
        include ActiveJob::TestHelper

        setup do
          @account_without_dependents = spina_admin_conferences_accounts :account_without_dependents
          @account_with_delegate = spina_admin_conferences_accounts :account_with_delegate
          @unconfirmed_account = spina_admin_conferences_accounts :unconfirmed_account
          @account_with_affiliations = spina_admin_conferences_accounts :account_with_affiliations
          @new_account = Account.new
        end

        test 'account has associated delegate' do
          assert_not_nil @account_with_delegate.delegate
          assert_nil @new_account.delegate
        end

        test 'account has associated affiliations' do
          assert_not_empty @account_with_affiliations.affiliations
          assert_empty @new_account.affiliations
        end

        test 'account has associated institutions' do
          assert_not_empty @account_with_affiliations.institutions
          assert_empty @new_account.institutions
        end

        test 'nullifies associated delegate' do
          assert_no_difference 'Delegate.count' do
            assert @account_with_delegate.destroy
          end
          assert_empty @account_with_delegate.errors[:base]
          assert_nil @account_with_delegate.delegate.account_id
        end

        test 'destroys associated affiliations' do
          assert_difference 'Affiliation.count', -1 do
            assert @account_with_affiliations.destroy
          end
          assert_empty @account_with_affiliations.affiliations
        end

        test 'account has secure password' do
          assert_includes @account_without_dependents.public_methods, :password=
          assert_includes @account_without_dependents.public_methods, :password_digest=
          assert_includes @account_without_dependents.public_methods, :password_confirmation=
        end

        test 'account has secure password reset token' do
          assert_includes @account_without_dependents.public_methods, :regenerate_password_reset_token
        end

        test 'must be confirmed on update' do
          assert @account_without_dependents.valid?
          assert_empty @account_without_dependents.errors[:unconfirmed]
          @account_without_dependents.unconfirmed = true
          assert @account_without_dependents.invalid?
          assert_not_empty @account_without_dependents.errors[:unconfirmed]
          new_account = Account.new(@account_without_dependents.attributes.merge(email_address: 'someone@someaddress.com'))
          assert new_account.valid?
          assert_empty new_account.errors[:unconfirmed]
          new_account.unconfirmed = true
          assert new_account.valid?
          assert_empty new_account.errors[:unconfirmed]
        end

        test 'email address must not be empty' do
          assert @account_without_dependents.valid?
          assert_empty @account_without_dependents.errors[:email_address]
          @account_without_dependents.email_address = nil
          assert @account_without_dependents.invalid?
          assert_not_empty @account_without_dependents.errors[:email_address]
        end

        test 'first name must not be empty' do
          assert @account_without_dependents.valid?
          assert_empty @account_without_dependents.errors[:first_name]
          @account_without_dependents.first_name = nil
          assert @account_without_dependents.invalid?
          assert_not_empty @account_without_dependents.errors[:first_name]
        end

        test 'last name must not be empty' do
          assert @account_without_dependents.valid?
          assert_empty @account_without_dependents.errors[:last_name]
          @account_without_dependents.last_name = nil
          assert @account_without_dependents.invalid?
          assert_not_empty @account_without_dependents.errors[:last_name]
        end

        test 'email address must be email address' do
          assert @account_without_dependents.valid?
          assert_empty @account_without_dependents.errors[:email_address]
          @account_without_dependents.email_address = 'foo'
          assert @account_without_dependents.invalid?
          assert_not_empty @account_without_dependents.errors[:email_address]
        end

        test 'password must not be empty on create' do
          new_account = Account.new(@account_without_dependents.attributes.merge(email_address: 'someone@someaddress.com'))
          assert new_account.valid?
          assert_empty new_account.errors[:password]
          new_account.password = nil
          assert new_account.invalid?
          assert_not_empty new_account.errors[:password]
        end

        test 'account deletion scheduling' do
          assert_enqueued_with job: DeleteUnconfirmedAccountJob do
            Account.create(@account_without_dependents.attributes.excluding('id', 'password_reset_token').merge(email_address: 'someone@someaddress.com'))
          end
        end

        test 'account deletion performing' do
          assert_performed_with job: DeleteUnconfirmedAccountJob do
            Account.create(@account_without_dependents.attributes.excluding('id', 'password_reset_token').merge(email_address: 'someone@someaddress.com'))
          end
        end

        test 'confirms account' do
          assert_changes -> { @unconfirmed_account.unconfirmed? } do
            @unconfirmed_account.confirm
          end
        end

        test 'cannot unconfirm account' do
          assert_no_changes -> { @account_without_dependents.unconfirmed? } do
            @account_without_dependents.update unconfirmed: false
          end
        end
      end
    end
  end
end
