# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {PresentationAttachment} objects.
      # @see PresentationAttachment
      class PresentationAttachmentsController < ApplicationController
        # @!group Actions

        # Renders a form for a {PresentationAttachment}.
        # @return [void]
        def new
          @presentation = Presentation.find_by(id: params[:presentation_id]) || Presentation.new
          @attachment = @presentation.attachments.build
          respond_to :js
          render locals: { index: params[:index].to_i, active: params[:active] == 'true' }
        end

        # @!endgroup
      end
    end
  end
end
