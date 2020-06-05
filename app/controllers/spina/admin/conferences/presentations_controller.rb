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
            add_breadcrumb t('.new')
            render :new
          end
        end

        def update
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path, success: t('.saved')
          else
            add_breadcrumb @presentation.title
            render :edit
          end
        end

        def destroy
          if @presentation.destroy
            redirect_to admin_conferences_presentations_path, success: t('.destroyed')
          else
            add_breadcrumb @presentation.title
            render :edit
          end
        end

        def import
          Presentation.import params[:file]
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
          params.require(:admin_conferences_presentation).permit(:title, :date, :start_time, :abstract, :session_id, presenter_ids: [])
        end
      end
    end
  end
end
