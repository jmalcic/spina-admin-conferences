# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DeleteUnconfirmedAccountJobTest < ActiveJob::TestCase
        setup do
          @account = spina_admin_conferences_accounts :joe_bloggs
          @unconfirmed_account = spina_admin_conferences_accounts :unconfirmed_account
          @new_account = Account.new
        end

        test 'destroys unconfirmed accounts' do
          assert_difference 'Account.count', -1 do
            DeleteUnconfirmedAccountJob.perform_now @unconfirmed_account
          end
        end

        test 'does not destroy confirmed accounts' do
          assert_no_difference 'Account.count' do
            DeleteUnconfirmedAccountJob.perform_now @account
          end
        end
      end
    end
  end
end
