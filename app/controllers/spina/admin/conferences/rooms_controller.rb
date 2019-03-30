# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages rooms and sets breadcrumbs
      class RoomsController < ::Spina::Admin::AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        layout 'spina/admin/conferences/institutions'

        def index
          @rooms = if params[:presentation_type_id]
                     Spina::Conferences::PresentationType.find(params[:presentation_type_id]).rooms
                   else
                     Spina::Conferences::Room.all
                   end
        end

        def new
          @room = Spina::Conferences::Room.new
          add_breadcrumb I18n.t('spina.conferences.rooms.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @room = Spina::Conferences::Room.find params[:id]
          add_breadcrumb @room.name
          render layout: 'spina/admin/admin'
        end

        def create
          @room = Spina::Conferences::Room.new(conference_params)
          add_breadcrumb I18n.t('spina.conferences.rooms.new')
          if @room.save
            redirect_to admin_conferences_rooms_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @room = Spina::Conferences::Room.find params[:id]
          add_breadcrumb @room.name
          if @room.update(conference_params)
            redirect_to admin_conferences_rooms_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @room = Spina::Conferences::Room.find params[:id]
          @room.destroy
          redirect_to admin_conferences_rooms_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.institutions'), admin_conferences_institutions_path
          add_breadcrumb I18n.t('spina.conferences.website.rooms'), admin_conferences_rooms_path
        end

        def set_tabs
          @tabs = %w{room_details presentations}
        end

        def conference_params
          params.require(:room).permit(:building, :number, :institution_id)
        end
      end
    end
  end
end
