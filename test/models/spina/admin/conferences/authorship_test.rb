# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class AuthorshipTest < ActiveSupport::TestCase
        setup do
          @valid_authorship = spina_admin_conferences_authorships :valid_authorship
          @new_authorship = Authorship.new
        end

        test 'authorship has associated presentation' do
          assert_not_nil @valid_authorship.presentation
          assert_nil @new_authorship.presentation
        end

        test 'authorship has associated delegation' do
          assert_not_nil @valid_authorship.delegation
          assert_nil @new_authorship.delegation
        end

        test 'presentation must not be empty' do
          assert @valid_authorship.valid?
          assert_empty @valid_authorship.errors[:presentation]
          @valid_authorship.presentation = nil
          assert @valid_authorship.invalid?
          assert_not_empty @valid_authorship.errors[:presentation]
        end

        test 'delegation must not be empty' do
          assert @valid_authorship.valid?
          assert_empty @valid_authorship.errors[:delegation]
          @valid_authorship.delegation = nil
          assert @valid_authorship.invalid?
          assert_not_empty @valid_authorship.errors[:delegation]
        end
      end
    end
  end
end
