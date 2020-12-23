# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegateTest < ActiveSupport::TestCase
        include ActiveJob::TestHelper

        setup do
          @delegate_without_dependents = spina_admin_conferences_delegates :delegate_without_dependents
          @delegate_without_dependents_with_account = spina_admin_conferences_delegates :delegate_with_account
          @delegate_without_dependents_with_authorships = spina_admin_conferences_delegates :delegate_with_authorships
          @delegate_without_dependents_with_dietary_requirements = spina_admin_conferences_delegates :delegate_with_dietary_requirements
          @delegate_without_dependents_with_delegations = spina_admin_conferences_delegates :delegate_with_delegations
          @new_delegate = Delegate.new
        end

        test 'delegate has associated account' do
          assert_not_nil @delegate_without_dependents_with_account.account
          assert_nil @new_delegate.account
        end

        test 'delegate has associated delegations' do
          assert_not_empty @delegate_without_dependents_with_delegations.delegations
          assert_empty @new_delegate.delegations
        end

        test 'delegate has associated conferences' do
          assert_not_empty @delegate_without_dependents_with_delegations.conferences
          assert_empty @new_delegate.conferences
        end

        test 'delegate has associated authorships' do
          assert_not_empty @delegate_without_dependents_with_authorships.authorships
          assert_empty @new_delegate.authorships
        end

        test 'delegate has associated presentations' do
          assert_not_empty @delegate_without_dependents_with_authorships.presentations
          assert_empty @new_delegate.presentations
        end

        test 'delegate has associated dietary requirements' do
          assert_not_empty @delegate_without_dependents_with_dietary_requirements.dietary_requirements
          assert_empty @new_delegate.dietary_requirements
        end

        test 'destroys associated delegations' do
          assert_difference 'Delegation.count', -1 do
            assert @delegate_without_dependents_with_delegations.destroy
          end
          assert_empty @delegate_without_dependents_with_delegations.errors[:base]
        end

        test 'accepts nested attributes for delegations' do
          assert_changes '@delegate_without_dependents_with_delegations.delegations.first.first_name' do
            @delegate_without_dependents_with_delegations
              .update(delegations_attributes: [{ id: @delegate_without_dependents_with_delegations.delegations.first.id, first_name: 'Leo' }])
          end
        end

        test 'email address must be email address' do
          assert @delegate_without_dependents.valid?
          assert_empty @delegate_without_dependents.errors[:email_address]
          @delegate_without_dependents.email_address = 'foo'
          assert @delegate_without_dependents.invalid?
          assert_not_empty @delegate_without_dependents.errors[:email_address]
        end

        test 'URL must be HTTP(S) URL' do
          assert @delegate_without_dependents.valid?
          assert_empty @delegate_without_dependents.errors[:url]
          @delegate_without_dependents.url = 'ftp://www.bbc.co.uk'
          assert @delegate_without_dependents.invalid?
          assert_not_empty @delegate_without_dependents.errors[:url], 'wrong protocol adds error'
          @delegate_without_dependents.restore_attributes
          @delegate_without_dependents.url = '\\'
          assert @delegate_without_dependents.invalid?
          assert_not_empty @delegate_without_dependents.errors[:url], 'malformed URL adds error'
        end

        test 'performs import job' do
          file_fixture('delegates.csv.erb').read
                                           .then { |file| ERB.new(file).result(binding) }
                                           .then { |result| Pathname.new(File.join(file_fixture_path, 'delegates.csv')).write(result) }
          assert_enqueued_jobs 1, only: DelegateImportJob do
            Delegate.import file_fixture('delegates.csv')
          end
        end
      end
    end
  end
end
