# frozen_string_literal: true

module Spina
  module Conferences
    # This class serves conferences as iCal
    class ConferencesController < ApplicationController
      include Eventable

      def index
        @conferences = Conference.sorted
        respond_to { |format| format.ics { render plain: make_calendar(@conferences).to_ical } }
      end

      def show
        @conference = Conference.find(params[:id])
        respond_to do |format|
          format.ics { render body: make_calendar(@conference, @conference.presentations).to_ical }
        end
      end
    end
  end
end
