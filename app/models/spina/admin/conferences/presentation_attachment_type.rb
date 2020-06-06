# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents presentation attachment types.
      class PresentationAttachmentType < ApplicationRecord
        translates :name, fallbacks: true

        scope :sorted, -> { i18n.order :name }

        has_many :presentation_attachments, class_name: 'Spina::Admin::Conferences::PresentationAttachment',
                                            foreign_key: 'attachment_type_id',
                                            dependent: :destroy,
                                            inverse_of: :attachment_type

        validates :name, presence: true
      end
    end
  end
end
