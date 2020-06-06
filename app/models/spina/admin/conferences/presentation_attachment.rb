# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class PresentationAttachment < ApplicationRecord
        belongs_to :presentation, inverse_of: :attachments
        belongs_to :attachment_type, class_name: 'Spina::Admin::Conferences::PresentationAttachmentType',
                   inverse_of: :presentation_attachments
        belongs_to :attachment, class_name: 'Spina::Attachment'

        delegate :name, to: :attachment_type, allow_nil: true
      end
    end
  end
end
