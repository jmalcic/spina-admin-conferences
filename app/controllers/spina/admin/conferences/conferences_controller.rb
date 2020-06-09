# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Conference} objects.
      # @see Conference
      class ConferencesController < ApplicationController
        before_action :set_conference, only: %i[edit update destroy]
        before_action :set_conferences_breadcrumb
        before_action :set_tabs
        before_action :set_institutions, only: %i[new edit]

        # @!group Actions

        # Renders a list of conferences.
        # @return [void]
        def index
          @conferences = Conference.sorted
        end

        # Renders a form for a new conference.
        # @return [void]
        def new
          @conference = Conference.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing conference.
        # @return [void]
        def edit
          add_breadcrumb @conference.name
        end

        # Creates a conference.
        # @return [void]
        def create
          @conference = Conference.new(conference_params)

          if @conference.save
            redirect_to admin_conferences_conferences_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @conference.errors } }
            end
          end
        end

        # Updates a conference.
        # @return [void]
        def update
          if @conference.update(conference_params)
            redirect_to admin_conferences_conferences_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @conference.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @conference.errors } }
            end
          end
        end

        # Destroys a conference.
        # @return [void]
        def destroy
          if @conference.destroy
            redirect_to admin_conferences_conferences_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @conference.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @conference.errors } }
            end
          end
        end

        # @!endgroup

        private

        def set_conference
          @conference = Conference.find params[:id]
        end

        def set_institutions
          @institutions = Institution.all.to_json include: { rooms: { methods: [:name] } }
        end

        def set_conferences_breadcrumb
          add_breadcrumb Conference.model_name.human(count: 0), admin_conferences_conferences_path
        end

        def set_tabs
          @tabs = %w[conference_details delegates presentation_types rooms presentations]
        end

        def conference_params
          params.require(:admin_conferences_conference).permit(:start_date, :finish_date, :name)
        end
      end
    end
  end
end
