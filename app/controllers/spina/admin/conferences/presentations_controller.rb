# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentations and sets breadcrumbs
      class PresentationsController < AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @presentations =
            if params[:room_id]
              Spina::Conferences::Room.find(params[:room_id])
                .presentations.sorted
            else
              Spina::Conferences::Presentation.sorted
            end
        end

        def new
          @presentation = Spina::Conferences::Presentation.new
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation = Spina::Conferences::Presentation.find params[:id]
          add_breadcrumb @presentation.title
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation = Spina::Conferences::Presentation.new presentation_params
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          if @presentation.save
            redirect_to admin_conferences_presentations_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation = Spina::Conferences::Presentation.find params[:id]
          add_breadcrumb @presentation.title
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation = Spina::Conferences::Presentation.find params[:id]
          @presentation.destroy
          redirect_to admin_conferences_presentation_types_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.presentations'),
                         admin_conferences_presentations_path
        end

        def set_tabs
          @tabs = %w[presentation_details presenters]
        end

        def presentation_params
          params.require(:presentation).permit(:title, :date, :start_time,
                                               :abstract, :room_use_id,
                                               presenter_ids: [])
        end
      end
    end
  end
end
