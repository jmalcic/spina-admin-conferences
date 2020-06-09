# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTypeTest < ActiveSupport::TestCase
        setup do
          @presentation_attachment_type = spina_admin_conferences_presentation_attachment_types :handout
          @new_presentation_attachment_type = PresentationAttachmentType.new
        end

        test 'translates name' do
          @presentation_attachment_type.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation_attachment_type.name
          @presentation_attachment_type.name = 'bar'
          assert_equal 'bar', @presentation_attachment_type.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation_attachment_type.name
        end

        test 'presentation attachment types have sorted scope' do
          assert_equal PresentationAttachmentType.i18n.order(:name), PresentationAttachmentType.sorted
        end

        test 'presentation attachment type has associated presentation attachments' do
          assert_not_empty @presentation_attachment_type.presentation_attachments
          assert_empty @new_presentation_attachment_type.presentation_attachments
        end

        # TODO: fix flaky test
        # test 'destroys associated presentation attachments' do
        #   assert_difference 'PresentationAttachment.count', -@presentation_attachment_type.presentation_attachments.count do
        #     assert @presentation_attachment_type.destroy
        #   end
        # end

        test 'name must not be empty' do
          assert @presentation_attachment_type.valid?
          assert_empty @presentation_attachment_type.errors[:name]
          @presentation_attachment_type.name = nil
          assert @presentation_attachment_type.invalid?
          assert_not_empty @presentation_attachment_type.errors[:name]
        end
      end
    end
  end
end
