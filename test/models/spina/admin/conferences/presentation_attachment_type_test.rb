# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTypeTest < ActiveSupport::TestCase
        test 'presentation attachment type attributes must not be empty' do
          presentation_attachment_type = PresentationAttachmentType.new
          assert presentation_attachment_type.invalid?
          assert presentation_attachment_type.errors[:name].any?
        end
      end
    end
  end
end
