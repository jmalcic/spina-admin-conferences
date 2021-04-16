# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {DietaryRequirement} objects.
      # @see DietaryRequirement
      class DietaryRequirementsController < ApplicationController
        before_action :set_dietary_requirement, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs

        # @!group Actions

        # Renders a list of dietary requirements.
        # @return [void]
        def index
          @dietary_requirements = DietaryRequirement.sorted.page(params[:page])
        end

        # Renders a form for a new dietary requirement.
        # @return [void]
        def new
          @dietary_requirement = DietaryRequirement.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing dietary requirement.
        # @return [void]
        def edit
          add_breadcrumb @dietary_requirement.name
        end

        # Creates a dietary requirement.
        # @return [void]
        def create # rubocop:disable Metrics/MethodLength
          @dietary_requirement = DietaryRequirement.new dietary_requirement_params

          if @dietary_requirement.save
            redirect_to admin_conferences_dietary_requirements_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @dietary_requirement.errors } }
            end
          end
        end

        # Updates a dietary requirement.
        # @return [void]
        def update # rubocop:disable Metrics/MethodLength
          if @dietary_requirement.update(dietary_requirement_params)
            redirect_to admin_conferences_dietary_requirements_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @dietary_requirement.name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @dietary_requirement.errors } }
            end
          end
        end

        # Destroys a dietary requirement.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @dietary_requirement.destroy
            redirect_to admin_conferences_dietary_requirements_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @dietary_requirement.name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @dietary_requirement.errors } }
            end
          end
        end

        # @!endgroup

        private

        def set_dietary_requirement
          @dietary_requirement = DietaryRequirement.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb DietaryRequirement.model_name.human(count: 0), admin_conferences_dietary_requirements_path
        end

        def set_tabs
          @tabs = %w[dietary_requirement_details delegates]
        end

        def dietary_requirement_params
          params.require(:dietary_requirement).permit(:name)
        end
      end
    end
  end
end
