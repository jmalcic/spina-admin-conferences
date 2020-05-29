# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTest < ActiveSupport::TestCase
        test 'presentation attachment attributes must not be empty' do
          presentation_attachment = PresentationAttachment.new
          assert presentation_attachment.invalid?
          assert presentation_attachment.errors[:presentation].any?
          assert presentation_attachment.errors[:presentation_attachment_type].any?
        end
      end
    end
  end
end
