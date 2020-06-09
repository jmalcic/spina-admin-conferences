# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {PresentationAttachmentType} objects.
      # @see PresentationAttachmentType
      class PresentationAttachmentTypesController < ApplicationController
        before_action :set_presentation_attachment_type, only: %i[edit update destroy]
        before_action :set_breadcrumb

        # @!group Actions

        # Renders a list of presentation attachment types.
        # @return [void]
        def index
          @presentation_attachment_types = PresentationAttachmentType.sorted
        end

        # Renders a form for a new presentation attachment type.
        # @return [void]
        def new
          @presentation_attachment_type = PresentationAttachmentType.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing presentation attachment type.
        # @return [void]
        def edit
          add_breadcrumb @presentation_attachment_type.name
        end

        # Creates a presentation attachment type.
        # @return [void]
        def create
          @presentation_attachment_type = PresentationAttachmentType.new presentation_attachment_type_params

          if @presentation_attachment_type.save
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @presentation_attachment_type.errors } }
            end
          end
        end

        # Updates a presentation attachment type.
        # @return [void]
        def update
          if @presentation_attachment_type.update(presentation_attachment_type_params)
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation_attachment_type.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @presentation_attachment_type.errors } }
            end
          end
        end

        # Destroys a presentation attachment type.
        # @return [void]
        def destroy
          if @presentation_attachment_type.destroy
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation_attachment_type.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @presentation_attachment_type.errors } }
            end
          end
        end

        # @!endgroup

        private

        def set_presentation_attachment_type
          @presentation_attachment_type = PresentationAttachmentType.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb PresentationAttachmentType.model_name.human(count: 0),
                         admin_conferences_presentation_attachment_types_path
        end

        def presentation_attachment_type_params
          params.require(:admin_conferences_presentation_attachment_type).permit(:name)
        end
      end
    end
  end
end
