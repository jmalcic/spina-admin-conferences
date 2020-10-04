# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class EmailAddressPartTest < ActiveSupport::TestCase
        setup do
          @email_address_part = spina_admin_conferences_email_address_parts :valid_email_address
          @new_email_address_part = EmailAddressPart.new
        end

        test 'email address part has associated page parts' do
          assert_not_empty @email_address_part.page_parts
          assert_empty @new_email_address_part.page_parts
        end

        test 'email address part has associated parts' do
          assert_not_empty @email_address_part.parts
          assert_empty @new_email_address_part.parts
        end

        test 'email address part has associated layout parts' do
          assert_not_empty @email_address_part.layout_parts
          assert_empty @new_email_address_part.layout_parts
        end

        test 'email address part has associated structure parts' do
          assert_not_empty @email_address_part.structure_parts
          assert_empty @new_email_address_part.structure_parts
        end

        test 'email address must be email address' do
          assert @email_address_part.valid?
          assert_empty @email_address_part.errors[:content]
          @email_address_part.content = 'John Doe, Example INC <john.doe@example.com>'
          assert @email_address_part.invalid?
          assert_not_empty @email_address_part.errors[:content]
        end
      end
    end
  end
end
