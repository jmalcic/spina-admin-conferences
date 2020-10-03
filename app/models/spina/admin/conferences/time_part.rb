# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Time parts.
      class TimePart < ApplicationRecord
        has_many :page_parts, as: :page_partable
        has_many :parts, as: :partable
        has_many :layout_parts, as: :layout_partable
        has_many :structure_parts, as: :structure_partable

        # @return [Date, nil] the date of the time part. Nil if the time part has no date and time
        def date
          return if content.blank?

          content.to_date
        end

        # Sets the date of the time part.
        # @param date [Date] the new date
        # @return [void]
        def date=(date)
          if date.blank? || date.to_date.blank?
            self.content = nil
            return
          end

          self.content = date.to_date + (content.try(:seconds_since_midnight) || 0).seconds
        end

        # @return [ActiveSupport::TimeWithZone, nil] the time of the time part. Nil if the time part has no date and time
        def time
          return if content.blank?

          content
        end

        # Sets the start time of the time part.
        # @param time [ActiveSupport::TimeWithZone] the new time
        # @return [void]
        def time=(time)
          if time.blank?
            self.content = nil
            return
          end

          self.content = Time.parse(time, date).to_datetime.in_time_zone
        end
      end
    end
  end
end
