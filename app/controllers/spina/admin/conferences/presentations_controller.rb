# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentations and sets breadcrumbs
      class PresentationsController < ApplicationController
        before_action :set_presentation, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs
        before_action :set_conferences, only: %i[new edit]

        def index
          @presentations = Presentation.sorted
        end

        def new
          @presentation = Presentation.new
          add_breadcrumb t('.new')
        end

        def edit
          add_breadcrumb @presentation.title
        end

        def create
          @presentation = Presentation.new presentation_params

          if @presentation.save
            redirect_to admin_conferences_presentations_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @presentation.errors } }
            end
          end
        end

        def update
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation.title
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @presentation.errors } }
            end
          end
        end

        def destroy
          if @presentation.destroy
            redirect_to admin_conferences_presentations_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation.title
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @presentation.errors } }
            end
          end
        end

        def import
          Presentation.import params[:file]
        end

        def attach
          @presentation = Presentation.find_by(id: params[:id]) || Presentation.new
          @attachment = @presentation.attachments.build
          respond_to :js
          render locals: { index: params[:index].to_i, active: params[:active] == 'true' }
        end

        private

        def set_presentation
          @presentation = Presentation.find params[:id]
        end

        def set_conferences
          @conferences = Conference.all.to_json methods: %i[name localized_dates],
                                                include:
                                                  { presentation_types:
                                                      { methods: [:name], include: { sessions: { methods: [:name] } } } }
        end

        def set_breadcrumb
          add_breadcrumb Presentation.model_name.human(count: 0), admin_conferences_presentations_path
        end

        def set_tabs
          @tabs = %w[presentation_details presenters]
        end

        def presentation_params
          params.require(:admin_conferences_presentation).permit(:title, :abstract, :session_id, :date, :start_time,
                                                                 presenter_ids: [],
                                                                 attachments_attributes:
                                                                   %i[id attachment_id attachment_type_id _destroy])
        end
      end
    end
  end
end
