# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Conference} objects.
      # @see Conference
      class ConferencesController < ApplicationController
        PARTS_PARAMS = [
          :name, :title, :type, :content, :filename, :signed_blob_id, :alt, :attachment_id, :image_id,
          { images_attributes: %i[filename signed_blob_id image_id alt],
            content_attributes: [
              :name, :title,
              { parts_attributes: [
                :name, :title, :type, :content, :filename, :signed_blob_id, :alt, :attachment_id, :image_id,
                { images_attributes: %i[filename signed_blob_id image_id alt] }
              ] }
            ] }
        ].freeze
        CONTENT_PARAMS = Spina.config.locales.inject({}) { |params, locale| params.merge("#{locale}_content_attributes": [*PARTS_PARAMS]) }
        PARAMS = [:start_date, :finish_date, :name, { **CONTENT_PARAMS,
          events_attributes: %i[id name start_datetime finish_datetime description location] }].freeze
        PARTS = %w[text submission_url submission_email_address submission_date submission_text gallery sponsors].freeze

        before_action :set_conference, only: %i[edit update destroy]
        before_action :set_conferences_breadcrumb
        before_action :set_tabs
        before_action :set_institutions, :set_parts_attributes, only: %i[new edit]
        before_action :build_parts, only: :edit

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
          build_parts
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing conference.
        # @return [void]
        def edit
          add_breadcrumb @conference.name
        end

        # Creates a conference.
        # @return [void]
        def create # rubocop:disable Metrics/MethodLength
          @conference = Conference.new(conference_params)

          if @conference.save
            redirect_to admin_conferences_conferences_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @conference.errors } }
            end
          end
        end

        # Updates a conference.
        # @return [void]
        def update # rubocop:disable Metrics/MethodLength
          if @conference.update(conference_params)
            redirect_to admin_conferences_conferences_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @conference.name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @conference.errors } }
            end
          end
        end

        # Destroys a conference.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @conference.destroy
            redirect_to admin_conferences_conferences_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @conference.name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @conference.errors } }
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
          @tabs = %w[conference_details parts delegates presentation_types rooms presentations]
        end

        def set_parts_attributes
          @parts_attributes = current_theme.parts.select { |part| PARTS.include? part[:name] }
        end

        def build_parts
          return unless @parts_attributes.is_a? Array

          @parts = @parts_attributes.collect { |part_attributes| @conference.part(part_attributes) }
        end

        def conference_params
          params.require(:conference).permit(PARAMS)
        end
      end
    end
  end
end
