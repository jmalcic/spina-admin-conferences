# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentation types
      class PresentationTypesController < AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        layout 'spina/admin/conferences/conferences'

        def index
          @presentation_types =
            if params[:conference_id]
              Spina::Conferences::Conference.find(params[:conference_id])
                                        .presentation_types.sorted
            else
              Spina::Conferences::PresentationType.sorted
            end
          respond_to do |format|
            format.html
            format.xml { render layout: false }
          end
        end

        def new
          @presentation_type = Spina::Conferences::PresentationType.new
          add_breadcrumb I18n.t('spina.conferences.presentation_types.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation_type = Spina::Conferences::PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation_type =
            Spina::Conferences::PresentationType.new presentation_type_params
          add_breadcrumb I18n.t('spina.conferences.presentation_types.new')
          if @presentation_type.save
            redirect_to admin_conferences_presentation_types_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation_type = Spina::Conferences::PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_conferences_presentation_types_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation_type = Spina::Conferences::PresentationType.find params[:id]
          @presentation_type.destroy
          redirect_to admin_conferences_presentation_types_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.conferences'),
                         admin_conferences_conferences_path
          add_breadcrumb I18n.t('spina.conferences.website.presentation_types'),
                         admin_conferences_presentation_types_path
        end

        def set_tabs
          @tabs = %w[presentation_type_details presentations rooms]
        end

        def presentation_type_params
          params.require(:presentation_type).permit(:name, :minutes,
                                                    :conference_id,
                                                    room_possession_ids: [])
        end

        def room_uses
          @presentation_type.room_uses.collect do |room_use|
            { id: room_use.id, room_name: room_use.room_name }
          end
        end
      end
    end
  end
end
