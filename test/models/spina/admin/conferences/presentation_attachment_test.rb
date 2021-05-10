# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTest < ActiveSupport::TestCase
        setup do
          @valid_presentation_attachment = spina_admin_conferences_presentation_attachments :valid_attachment
          @new_presentation_attachment = PresentationAttachment.new
        end

        test 'presentation attachment has associated presentation' do
          assert_not_nil @valid_presentation_attachment.presentation
          assert_nil @new_presentation_attachment.presentation
        end

        test 'presentation attachment has associated attachment type' do
          assert_not_nil @valid_presentation_attachment.attachment_type
          assert_nil @new_presentation_attachment.attachment_type
        end

        test 'presentation attachment has associated attachment' do
          assert_not_nil @valid_presentation_attachment.attachment
          assert_nil @new_presentation_attachment.attachment
        end

        test 'presentation must not be empty' do
          assert @valid_presentation_attachment.valid?
          assert_empty @valid_presentation_attachment.errors[:presentation]
          @valid_presentation_attachment.presentation = nil
          assert @valid_presentation_attachment.invalid?
          assert_not_empty @valid_presentation_attachment.errors[:presentation]
        end

        test 'presentation attachment type must not be empty' do
          assert @valid_presentation_attachment.valid?
          assert_empty @valid_presentation_attachment.errors[:attachment_type]
          @valid_presentation_attachment.attachment_type = nil
          assert @valid_presentation_attachment.invalid?
          assert_not_empty @valid_presentation_attachment.errors[:attachment_type]
        end

        test 'attachment must not be empty' do
          assert @valid_presentation_attachment.valid?
          assert_empty @valid_presentation_attachment.errors[:attachment]
          @valid_presentation_attachment.attachment = nil
          assert @valid_presentation_attachment.invalid?
          assert_not_empty @valid_presentation_attachment.errors[:attachment]
        end

        test 'returns name' do
          assert_equal @valid_presentation_attachment.name, @valid_presentation_attachment.attachment_type.name
          assert_nil @new_presentation_attachment.name
        end
      end
    end
  end
end
