# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # URL parts. The format is validated.
      #
      # = Validators
      # HTTP(S) URL (using {HttpUrlValidator}):: {#content}.
      # @see HttpUrlValidator
      class UrlPart < ApplicationRecord
        has_many :page_parts, as: :page_partable
        has_many :parts, as: :partable
        has_many :layout_parts, as: :layout_partable
        has_many :structure_parts, as: :structure_partable

        validates :content, 'spina/admin/conferences/http_url': true, allow_blank: true
      end
    end
  end
end
