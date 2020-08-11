# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Event} objects.
      # @see Event
      class EventsController < ApplicationController
        # @!group Actions

        # Renders a form for an {Event}.
        # @return [void]
        def new
          @conference = Conference.find_by(id: params[:conference]) || Conference.new
          @event = @conference.events.build
          respond_to :js
          render locals: { index: params[:index].to_i, active: params[:active] == 'true' }
        end

        # @!endgroup
      end
    end
  end
end
