# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages rooms and sets breadcrumbs
      class RoomsController < ApplicationController
        before_action :set_room, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs

        layout 'spina/admin/conferences/institutions'

        def index
          @rooms = Room.all
        end

        def new
          @room = Room.new
          add_breadcrumb I18n.t('spina.conferences.rooms.new')
        end

        def edit
          add_breadcrumb @room.name
        end

        def create
          @room = Room.new(room_params)

          if @room.save
            redirect_to admin_conferences_rooms_path, success: t('spina.conferences.rooms.saved')
          else
            add_breadcrumb I18n.t('spina.conferences.rooms.new')
            render :new
          end
        end

        def update
          if @room.update(room_params)
            redirect_to admin_conferences_rooms_path, success: t('spina.conferences.rooms.saved')
          else
            add_breadcrumb @room.name
            render :edit
          end
        end

        def destroy
          if @room.destroy
            redirect_to admin_conferences_rooms_path, success: t('spina.conferences.rooms.destroyed')
          else
            add_breadcrumb @room.name
            render :edit
          end
        end

        private

        def set_room
          @room = Room.find params[:id]
        end

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
