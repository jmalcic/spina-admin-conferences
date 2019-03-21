# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents times.
    class TimePart < ApplicationRecord
      attr_writer :date

      has_many :page_parts, as: :page_partable
      has_many :layout_parts, as: :layout_partable
      has_many :structure_parts, as: :structure_partable

      def date
        content&.to_date
      end

      def time
        content || nil
      end

      def time=(time)
        @time = time
        return unless @date

        self.content = "#{@date} #{@time}".to_datetime.in_time_zone
      end
    end
  end
end
