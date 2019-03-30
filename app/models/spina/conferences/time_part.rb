# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents times.
    class TimePart < ApplicationRecord
      after_initialize :set_from_content
      before_validation :update_content

      attribute :date, :date
      attribute :time, :time

      has_many :page_parts, as: :page_partable
      has_many :layout_parts, as: :layout_partable
      has_many :structure_parts, as: :structure_partable

      def set_from_content
        return unless content

        self.date ||= content.to_date
        self.time ||= content
      end

      def update_content
        self.content = "#{date} #{time}".to_time.in_time_zone if date && time
      end
    end
  end
end
