# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegationAffiliationTest < ActiveSupport::TestCase
        setup do
          @valid_delegation_affiliation = spina_admin_conferences_delegation_affiliations :valid_delegation_affiliation
          @new_delegation_affiliation = DelegationAffiliation.new
        end

        test 'delegation affiliation has associated delegation' do
          assert_not_nil @valid_delegation_affiliation.delegation
          assert_nil @new_delegation_affiliation.delegation
        end

        test 'delegation affiliation has associated institution' do
          assert_not_nil @valid_delegation_affiliation.institution
          assert_nil @new_delegation_affiliation.institution
        end

        test 'delegation must not be empty' do
          assert @valid_delegation_affiliation.valid?
          assert_empty @valid_delegation_affiliation.errors[:delegation]
          @valid_delegation_affiliation.delegation = nil
          assert @valid_delegation_affiliation.invalid?
          assert_not_empty @valid_delegation_affiliation.errors[:delegation]
        end

        test 'institution must not be empty' do
          assert @valid_delegation_affiliation.valid?
          assert_empty @valid_delegation_affiliation.errors[:institution]
          @valid_delegation_affiliation.institution = nil
          assert @valid_delegation_affiliation.invalid?
          assert_not_empty @valid_delegation_affiliation.errors[:institution]
        end
      end
    end
  end
end
