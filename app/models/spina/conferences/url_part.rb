# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents URLs. The format is validated.
    class UrlPart < ApplicationRecord
      has_many :page_parts, as: :page_partable
      has_many :layout_parts, as: :layout_partable
      has_many :structure_parts, as: :structure_partable

      validates :content, http_url: true
    end
  end
end
