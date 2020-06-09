# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Room} objects.
      # @see Room
      class RoomsController < ApplicationController
        before_action :set_room, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs

        layout 'spina/admin/conferences/institutions'

        # @!group Actions

        # Renders a list of rooms.
        # @return [void]
        def index
          @rooms = Room.sorted
        end

        # Renders a form for a new room.
        # @return [void]
        def new
          @room = Room.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing room.
        # @return [void]
        def edit
          add_breadcrumb @room.name
        end

        # Creates a room.
        # @return [void]
        def create # rubocop:disable Metrics/MethodLength
          @room = Room.new(room_params)

          if @room.save
            redirect_to admin_conferences_rooms_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @room.errors } }
            end
          end
        end

        # Updates a room.
        # @return [void]
        def update # rubocop:disable Metrics/MethodLength
          if @room.update(room_params)
            redirect_to admin_conferences_rooms_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @room.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @room.errors } }
            end
          end
        end

        # Destroys a room.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @room.destroy
            redirect_to admin_conferences_rooms_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @room.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @room.errors } }
            end
          end
        end

        # @!endgroup

        private

        def set_room
          @room = Room.find params[:id]
        end

        def set_breadcrumbs
          add_breadcrumb Institution.model_name.human(count: 0), admin_conferences_institutions_path
          add_breadcrumb Room.model_name.human(count: 0), admin_conferences_rooms_path
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
