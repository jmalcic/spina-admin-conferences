# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DelegationTest < ActiveSupport::TestCase
        setup do
          @delegation_with_affiliations = spina_admin_conferences_delegations :delegation_with_affiliations
          @delegation_with_authorships = spina_admin_conferences_delegations :delegation_with_authorships
          @delegation_with_affiliations = spina_admin_conferences_delegations :delegation_with_affiliations
          @new_delegation = Delegation.new
        end

        test 'delegations have sorted scope' do
          assert_equal Delegation.order(:last_name, :first_name), Delegation.sorted
        end

        test 'delegation has associated delegate' do
          assert_not_nil @delegation_with_affiliations.delegate
          assert_nil @new_delegation.delegate
        end

        test 'delegation has associated conference' do
          assert_not_nil @delegation_with_affiliations.conference
          assert_nil @new_delegation.conference
        end

        test 'delegation has associated affiliations' do
          assert_not_empty @delegation_with_affiliations.affiliations
          assert_empty @new_delegation.affiliations
        end

        test 'delegation has associated authorships' do
          assert_not_empty @delegation_with_authorships.authorships
          assert_empty @new_delegation.authorships
        end

        test 'delegation has associated institutions' do
          assert_not_empty @delegation_with_affiliations.institutions
          assert_empty @new_delegation.institutions
        end

        test 'destroys associated affiliations' do
          assert_difference 'DelegationAffiliation.count', -1 do
            assert @delegation_with_affiliations.destroy
          end
          assert_empty @delegation_with_affiliations.errors[:base]
        end

        test 'destroys associated authorships' do
          assert_difference 'Authorship.count', -1 do
            assert @delegation_with_authorships.destroy
          end
          assert_empty @delegation_with_authorships.errors[:base]
        end

        test 'delegate must not be empty' do
          assert @delegation_with_affiliations.valid?
          assert_empty @delegation_with_affiliations.errors[:delegate]
          @delegation_with_affiliations.delegate = nil
          assert @delegation_with_affiliations.invalid?
          assert_not_empty @delegation_with_affiliations.errors[:delegate]
        end

        test 'conference must not be empty' do
          assert @delegation_with_affiliations.valid?
          assert_empty @delegation_with_affiliations.errors[:conference]
          @delegation_with_affiliations.conference = nil
          assert @delegation_with_affiliations.invalid?
          assert_not_empty @delegation_with_affiliations.errors[:conference]
        end

        test 'first name must not be empty' do
          assert @delegation_with_affiliations.valid?
          assert_empty @delegation_with_affiliations.errors[:first_name]
          @delegation_with_affiliations.first_name = nil
          assert @delegation_with_affiliations.invalid?
          assert_not_empty @delegation_with_affiliations.errors[:first_name]
        end

        test 'last name must not be empty' do
          assert @delegation_with_affiliations.valid?
          assert_empty @delegation_with_affiliations.errors[:last_name]
          @delegation_with_affiliations.last_name = nil
          assert @delegation_with_affiliations.invalid?
          assert_not_empty @delegation_with_affiliations.errors[:last_name]
        end

        test 'returns localized full name' do
          assert_equal Delegation.human_attribute_name(:full_name, first_name: @delegation_with_affiliations.first_name,
                                                                   last_name: @delegation_with_affiliations.last_name),
                       @delegation_with_affiliations.full_name
          assert_nil @new_delegation.full_name
        end

        test 'returns localized full name and institution' do
          assert_equal Delegation.human_attribute_name(:name_and_institution, name: @delegation_with_affiliations.full_name,
                                                                              institution:
                                                                                @delegation_with_affiliations
                                                                                  .institutions.collect(&:name).to_sentence),
                       @delegation_with_affiliations.full_name_and_institution
          assert_nil @new_delegation.full_name_and_institution
        end

        test 'returns localized reversed name' do
          assert_equal Delegation.human_attribute_name(:reversed_name, first_name: @delegation_with_affiliations.first_name,
                                                                       last_name: @delegation_with_affiliations.last_name),
                       @delegation_with_affiliations.reversed_name
          assert_nil @new_delegation.reversed_name
        end

        test 'returns localized reversed name and institution' do
          assert_equal Delegation.human_attribute_name(:name_and_institution, name: @delegation_with_affiliations.reversed_name,
                                                                              institution:
                                                                                @delegation_with_affiliations
                                                                                  .institutions.collect(&:name).to_sentence),
                       @delegation_with_affiliations.reversed_name_and_institution
          assert_nil @new_delegation.reversed_name_and_institution
        end
      end
    end
  end
end
