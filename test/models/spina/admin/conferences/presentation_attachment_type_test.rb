# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTypeTest < ActiveSupport::TestCase
        setup do
          @presentation_attachment_type_with_attachments = spina_admin_conferences_presentation_attachment_types :attachment_type_with_attachments
          @new_presentation_attachment_type = PresentationAttachmentType.new
        end

        test 'translates name' do
          @presentation_attachment_type_with_attachments.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation_attachment_type_with_attachments.name
          @presentation_attachment_type_with_attachments.name = 'bar'
          assert_equal 'bar', @presentation_attachment_type_with_attachments.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation_attachment_type_with_attachments.name
        end

        test 'presentation attachment types have sorted scope' do
          assert_equal PresentationAttachmentType.i18n.order(:name), PresentationAttachmentType.sorted
        end

        test 'presentation attachment type has associated presentation attachments' do
          assert_not_empty @presentation_attachment_type_with_attachments.presentation_attachments
          assert_empty @new_presentation_attachment_type.presentation_attachments
        end

        test 'destroys associated presentation attachments' do
          assert_difference 'PresentationAttachment.count', -@presentation_attachment_type_with_attachments.presentation_attachments.count do
            assert @presentation_attachment_type_with_attachments.destroy
          end
        end

        test 'name must not be empty' do
          assert @presentation_attachment_type_with_attachments.valid?
          assert_empty @presentation_attachment_type_with_attachments.errors[:name]
          @presentation_attachment_type_with_attachments.name = nil
          assert @presentation_attachment_type_with_attachments.invalid?
          assert_not_empty @presentation_attachment_type_with_attachments.errors[:name]
        end
      end
    end
  end
end
