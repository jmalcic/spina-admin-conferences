# frozen_string_literal: true

module Spina
  module Conferences
    class PresentationAttachment < ApplicationRecord
      belongs_to :presentation
      belongs_to :presentation_attachment_type
    end
  end
end
