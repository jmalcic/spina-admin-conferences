# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Presentation attachment type records.
      #
      # = Validators
      # Presence:: {#name}.
      #
      # = Translations
      # - {#name}
      class PresentationAttachmentType < ApplicationRecord
        # @!attribute [rw] name
        #   @return [String, nil] the name of the presentation attachment type
        translates :name, fallbacks: true

        # @return [ActiveRecord::Relation] all presentation attachment types, ordered by name
        scope :sorted, -> { i18n.order :name }

        # @!attribute [rw] presentation_attachments
        #   @return [ActiveRecord::Relation] directly associated presentation attachments
        #   @see PresentationAttachment
        has_many :presentation_attachments, class_name: 'Spina::Admin::Conferences::PresentationAttachment',
                                            foreign_key: 'attachment_type_id',
                                            dependent: :destroy,
                                            inverse_of: :attachment_type

        validates :name, presence: true
      end
    end
  end
end
