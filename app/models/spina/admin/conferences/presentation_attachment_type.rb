# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents presentation attachment types.
      class PresentationAttachmentType < ApplicationRecord
        has_many :presentation_attachments, dependent: :destroy

        validates :name, presence: true

        scope :sorted, -> { order :name }
      end
    end
  end
end
