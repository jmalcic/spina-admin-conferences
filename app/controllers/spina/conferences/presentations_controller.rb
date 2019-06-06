# frozen_string_literal: true

module Spina
  module Conferences
    # This class serves presentations as iCal
    class PresentationsController < ApplicationController
      include Eventable

      def index
        @presentations = if params[:conference_id]
                           Conference.find(params[:conference_id]).presentations
                         else
                           Presentation.sorted
                         end
        respond_to { |format| format.ics { render plain: make_calendar(@presentations).to_ical } }
      end

      def show
        @presentation = Presentation.find(params[:id])
        respond_to do |format|
          format.ics { render body: make_calendar(@presentation).to_ical }
        end
      end
    end
  end
end
