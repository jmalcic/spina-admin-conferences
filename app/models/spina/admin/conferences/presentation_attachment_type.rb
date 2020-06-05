# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents presentation attachment types.
      class PresentationAttachmentType < ApplicationRecord
        translates :name, fallbacks: true

        scope :sorted, -> { order :name }

        has_many :presentation_attachments, dependent: :destroy

        validates :name, presence: true
      end
    end
  end
end
