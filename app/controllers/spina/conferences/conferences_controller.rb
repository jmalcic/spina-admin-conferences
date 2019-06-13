# frozen_string_literal: true

module Spina
  module Conferences
    # This class serves conferences as iCal
    class ConferencesController < ApplicationController
      include Eventable

      def index
        @conferences = Conference.includes(:institution).sorted
        respond_to do |format|
          format.ics { render body: make_calendar(@conferences, name: current_account.name).to_ical }
        end
      end

      def show
        @conference = Conference.includes(:institution,
                                          presentations: [:presentation_type,
                                                          presenters: :institution,
                                                          room_use: [room_possession: :room]]).find(params[:id])
        respond_to do |format|
          format.ics do
            render body: make_calendar(@conference, @conference.presentations, name: @conference.name).to_ical
          end
        end
      end
    end
  end
end
