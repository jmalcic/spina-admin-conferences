# frozen_string_literal: true

module Spina
  module Conferences
    # This module supports rendering events as iCal
    module Eventable
      extend ActiveSupport::Concern

      def make_calendar(*objects, **options)
        calendar = Icalendar::Calendar.new
        calendar.x_wr_calname = options[:name] if options[:name]
        objects.flatten!
        objects.each { |object| calendar.add_event(object.to_ics) }
        calendar
      end
    end
  end
end
