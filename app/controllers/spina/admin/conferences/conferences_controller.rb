# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Conference} objects.
      # @see Conference
      class ConferencesController < ApplicationController
        PARTS = [
          { name: 'text', title: 'Text', partable_type: 'Spina::Text' },
          { name: 'submission_url', title: 'Submission URL', partable_type: 'Spina::Admin::Conferences::UrlPart' },
          { name: 'submission_email_address', title: 'Submission email address',
            partable_type: 'Spina::Admin::Conferences::EmailAddressPart' },
          { name: 'submission_date', title: 'Submission date', partable_type: 'Spina::Admin::Conferences::DatePart' },
          { name: 'submission_text', title: 'Submission text', partable_type: 'Spina::Line' },
          { name: 'gallery', title: 'Gallery', partable_type: 'Spina::ImageCollection' },
          { name: 'sponsors', title: 'Sponsors', partable_type: 'Spina::Structure' }
        ].freeze

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
          @parts_attributes = PARTS
        end

        def build_parts
          return unless @parts_attributes.is_a? Array

          @conference.parts = @parts_attributes.collect do |part_attributes|
            @conference.parts.where(name: part_attributes[:name]).first_or_initialize(**part_attributes)
                       .tap { |part| part.partable ||= part.partable_type.constantize.new }
          end
        end

        def conference_params # rubocop:disable Metrics/MethodLength
          params.require(:admin_conferences_conference).permit(:start_date, :finish_date, :name,
                                                               events_attributes:
                                                                 %i[id name date start_time finish_time description location],
                                                               parts_attributes:
                                                                 [:id, :title, :name, :partable_type, :partable_id,
                                                                  { partable_attributes:
                                                                      [:id, :content, :image_tokens, :image_positions, :date, :time,
                                                                       { structure_items_attributes:
                                                                           [:id, :position, :_destroy,
                                                                            { structure_parts_attributes:
                                                                                [:id, :title, :structure_partable_type, :name, :partable_id,
                                                                                 { partable_attributes: {} }] }] }] }])
        end
      end
    end
  end
end
