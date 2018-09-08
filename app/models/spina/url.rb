# frozen_string_literal: true

module Spina
  # This class represents URLs.
  # The format is validated.
  class Url < ApplicationRecord
    has_many :page_parts, as: :page_partable
    has_many :layout_parts, as: :layout_partable
    has_many :structure_parts, as: :structure_partable

    validates :content, http_url: true, unless: proc { |a| a.content.blank? }
  end
end
