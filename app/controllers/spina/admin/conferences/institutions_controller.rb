# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Institution} objects.
      # @see Institution
      class InstitutionsController < ApplicationController
        before_action :set_institution, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs

        # @!group Actions

        # Renders a list of institutions.
        # @return [void]
        def index
          @institutions = Institution.sorted
        end

        # Renders a form for a new institution.
        # @return [void]
        def new
          @institution = Institution.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing institution.
        # @return [void]
        def edit
          add_breadcrumb @institution.name
        end

        # Creates an institution.
        # @return [void]
        def create # rubocop:disable Metrics/MethodLength
          @institution = Institution.new(conference_params)

          if @institution.save
            redirect_to admin_conferences_institutions_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @institution.errors } }
            end
          end
        end

        # Updates an institution.
        # @return [void]
        def update # rubocop:disable Metrics/MethodLength
          if @institution.update(conference_params)
            redirect_to admin_conferences_institutions_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @institution.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @institution.errors } }
            end
          end
        end

        # Destroys an institution.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @institution.destroy
            redirect_to admin_conferences_institutions_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @institution.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @institution.errors } }
            end
          end
        end

        # @!endgroup

        private

        def set_institution
          @institution = Institution.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb Institution.model_name.human(count: 0), admin_conferences_institutions_path
        end

        def set_tabs
          @tabs = %w[institution_details rooms delegates]
        end

        def conference_params
          params.require(:admin_conferences_institution).permit(:name, :city, :logo_id)
        end
      end
    end
  end
end
