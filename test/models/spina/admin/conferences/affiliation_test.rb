# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class AffiliationTest < ActiveSupport::TestCase
        setup do
          @valid_affiliation = spina_admin_conferences_affiliations :valid_affiliation
          @new_affiliation = Affiliation.new
        end

        test 'affiliation has associated account' do
          assert_not_nil @valid_affiliation.account
          assert_nil @new_affiliation.account
        end

        test 'affiliation has associated institution' do
          assert_not_nil @valid_affiliation.institution
          assert_nil @new_affiliation.institution
        end

        test 'account must not be empty' do
          assert @valid_affiliation.valid?
          assert_empty @valid_affiliation.errors[:account]
          @valid_affiliation.account = nil
          assert @valid_affiliation.invalid?
          assert_not_empty @valid_affiliation.errors[:account]
        end

        test 'institution must not be empty' do
          assert @valid_affiliation.valid?
          assert_empty @valid_affiliation.errors[:institution]
          @valid_affiliation.institution = nil
          assert @valid_affiliation.invalid?
          assert_not_empty @valid_affiliation.errors[:institution]
        end
      end
    end
  end
end
