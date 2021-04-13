# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {PresentationType} objects.
      # @see PresentationType
      class PresentationTypesController < ApplicationController
        before_action :set_presentation_type, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs

        layout 'spina/admin/conferences/conferences'

        # @!group Actions

        # Renders a list of presentation types.
        # @return [void]
        def index
          @presentation_types = PresentationType.sorted
        end

        # Renders a form for a new presentation type.
        # @return [void]
        def new
          @presentation_type = PresentationType.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing presentation type.
        # @return [void]
        def edit
          add_breadcrumb @presentation_type.name
        end

        # Creates a presentation type.
        # @return [void]
        def create # rubocop:disable Metrics/MethodLength
          @presentation_type = PresentationType.new presentation_type_params

          if @presentation_type.save
            redirect_to admin_conferences_presentation_types_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @presentation_type.errors } }
            end
          end
        end

        # Updates a presentation type.
        # @return [void]
        def update # rubocop:disable Metrics/MethodLength
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_conferences_presentation_types_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation_type.name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @presentation_type.errors } }
            end
          end
        end

        # Destroys a presentation type.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @presentation_type.destroy
            redirect_to admin_conferences_presentation_types_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation_type.name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @presentation_type.errors } }
            end
          end
        end

        # @!endgroup

        private

        def set_presentation_type
          @presentation_type = PresentationType.find params[:id]
        end

        def set_breadcrumbs
          add_breadcrumb Conference.model_name.human(count: 0), admin_conferences_conferences_path
          add_breadcrumb PresentationType.model_name.human(count: 0), admin_conferences_presentation_types_path
        end

        def set_tabs
          @tabs = %w[presentation_type_details presentations sessions]
        end

        def presentation_type_params
          params.require(:presentation_type).permit(:name, :conference_id, :minutes)
        end
      end
    end
  end
end
