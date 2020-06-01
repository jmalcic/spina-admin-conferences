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
          @rooms = Room.all
        end

        def new
          @room = Room.new
          add_breadcrumb I18n.t('spina.conferences.rooms.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @room = Room.find params[:id]
          add_breadcrumb @room.name
          render layout: 'spina/admin/admin'
        end

        def create
          @room = Room.new(room_params)
          add_breadcrumb I18n.t('spina.conferences.rooms.new')
          if @room.save
            redirect_to admin_conferences_rooms_path, flash: { success: t('spina.conferences.rooms.saved') }
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @room = Room.find params[:id]
          add_breadcrumb @room.name
          if @room.update(room_params)
            redirect_to admin_conferences_rooms_path, flash: { success: t('spina.conferences.rooms.saved') }
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @room = Room.find params[:id]
          @room.destroy
          redirect_to admin_conferences_rooms_path, flash: { success: t('spina.conferences.rooms.destroyed') }
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.institutions'), admin_conferences_institutions_path
          add_breadcrumb I18n.t('spina.conferences.website.rooms'), admin_conferences_rooms_path
        end

        def set_tabs
          @tabs = %w[room_details presentations]
        end

        def room_params
          params.require(:admin_conferences_room).permit(:building, :number, :institution_id)
        end
      end
    end
  end
end
