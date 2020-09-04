# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class represents dates, without associated times.
      class DatePart < ApplicationRecord
        has_many :page_parts, as: :page_partable
        has_many :parts, as: :partable
        has_many :layout_parts, as: :layout_partable
        has_many :structure_parts, as: :structure_partable
      end
    end
  end
end
