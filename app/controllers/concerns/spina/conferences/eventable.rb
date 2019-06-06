# frozen_string_literal: true

module Spina
  module Conferences
    # This module supports rendering events as iCal
    module Eventable
      extend ActiveSupport::Concern

      def make_calendar(*objects)
        calendar = Icalendar::Calendar.new
        objects.flatten!
        objects.each { |object| calendar.add_event(object.to_ics) }
        calendar.publish
        calendar
      end
    end
  end
end
