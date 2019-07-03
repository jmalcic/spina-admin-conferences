# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentations and sets breadcrumbs
      class PresentationsController < ::Spina::Admin::AdminController
        include ::Spina::Conferences

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @presentations = Presentation.sorted
        end

        def new
          @presentation = params[:presentation] ? Presentation.new(presentation_params) : Presentation.new
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          set_parts
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation = Presentation.find params[:id]
          add_breadcrumb @presentation.title
          set_parts
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation = Presentation.new presentation_params
          add_breadcrumb I18n.t('spina.conferences.presentations.new')
          if @presentation.save
            redirect_to admin_conferences_presentations_path
          else
            set_parts
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation = Presentation.find params[:id]
          add_breadcrumb @presentation.title
          if @presentation.update(presentation_params)
            redirect_to admin_conferences_presentations_path
          else
            set_parts
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation = Presentation.find params[:id]
          @presentation.destroy
          redirect_to admin_conferences_presentations_path
        end

        def import
          Presentation.import params[:file]
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.presentations'), admin_conferences_presentations_path
        end

        def set_parts
          @parts = @presentation.model_parts(current_theme).map { |part| @presentation.part(part) }
        end

        def set_tabs
          @tabs = %w[presentation_details content presenters]
        end

        def presentation_params
          params.require(:presentation).permit(:title, :date, :start_time, :abstract, :room_use_id,
                                               presenter_ids: [],
                                               parts_attributes: [:id, :title, :name, :partable_type, :partable_id,
                                                                  partable_attributes: {}])
        end
      end
    end
  end
end
