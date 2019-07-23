# frozen_string_literal: true

module Spina
  module Conferences
    # User-facing controller for presentations, serving both html and ics
    class PresentationsController < ApplicationController
      include Eventable
      include Templatable

      layout 'conference/application'

      def show
        @presentation = Presentation.includes(:presentation_type,
                                              presenters: :institution,
                                              room_use: [room_possession: :room]).find(params[:id])
        respond_to do |format|
          format.html
          format.ics { render body: make_calendar(@presentation).to_ical }
        end
      end
    end
  end
end
