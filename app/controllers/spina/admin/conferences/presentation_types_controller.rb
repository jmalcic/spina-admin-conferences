# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentation types
      class PresentationTypesController < ::Spina::Admin::AdminController
        include ::Spina::Conferences

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        layout 'spina/admin/conferences/conferences'

        def index
          @presentation_types = PresentationType.sorted
        end

        def new
          @presentation_type = PresentationType.new
          add_breadcrumb I18n.t('spina.conferences.presentation_types.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation_type = PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation_type = PresentationType.new presentation_type_params
          add_breadcrumb I18n.t('spina.conferences.presentation_types.new')
          if @presentation_type.save
            redirect_to admin_conferences_presentation_types_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation_type = PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_conferences_presentation_types_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation_type = PresentationType.find params[:id]
          @presentation_type.destroy
          redirect_to admin_conferences_presentation_types_path
        end

        def import
          PresentationType.import params[:file]
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.conferences'), admin_conferences_conferences_path
          add_breadcrumb I18n.t('spina.conferences.website.presentation_types'),
                         admin_conferences_presentation_types_path
        end

        def set_tabs
          @tabs = %w[presentation_type_details presentations rooms]
        end

        def presentation_type_params
          params.require(:presentation_type).permit(:name, :minutes, :conference_id, room_possession_ids: [])
        end
      end
    end
  end
end
