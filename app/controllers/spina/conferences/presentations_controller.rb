# frozen_string_literal: true

module Spina
  module Conferences
    # This class serves presentations as iCal
    class PresentationsController < ApplicationController
      include Eventable

      def show
        @presentation = Presentation.includes(:presentation_type,
                                              presenters: :institution,
                                              room_use: [room_possession: :room]).find(params[:id])
        respond_to { |format| format.ics { render body: make_calendar(@presentation).to_ical } }
      end
    end
  end
end
