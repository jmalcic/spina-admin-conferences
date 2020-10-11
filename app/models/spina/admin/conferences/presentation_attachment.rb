# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Presentation attachment records.
      class PresentationAttachment < ApplicationRecord
        # @!attribute [rw] presentation
        #   @return [Presentation, nil] directly associated presentation
        belongs_to :presentation, -> { includes(:translations) }, inverse_of: :attachments, touch: true
        # @!attribute [rw] presentation_attachment_type
        #   @return [PresentationAttachmentType, nil] directly associated presentation attachment type
        belongs_to :attachment_type, -> { includes(:translations) }, class_name: 'Spina::Admin::Conferences::PresentationAttachmentType',
                                                                     inverse_of: :presentation_attachments,
                                                                     touch: true
        # @!attribute [rw] attachment
        #   @return [Spina::Attachment, nil] directly associated attachment
        belongs_to :attachment, class_name: 'Spina::Attachment'

        # @!method name
        #   @return [String, nil] name of associated presentation attachment type
        #   @note Delegated to {#presentation_attachment_type}.
        delegate :name, to: :attachment_type, allow_nil: true
      end
    end
  end
end
