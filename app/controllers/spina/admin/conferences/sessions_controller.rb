# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages session and sets breadcrumbs
      class SessionsController < ApplicationController
        before_action :set_session, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs
        before_action :set_conferences, :set_institutions, only: %i[new edit]

        layout 'spina/admin/conferences/conferences'

        def index
          @sessions = Session.all
        end

        def new
          @session = Session.new
          add_breadcrumb t('.new')
        end

        def edit
          add_breadcrumb @session.name
        end

        def create
          @session = Session.new(session_params)

          if @session.save
            redirect_to admin_conferences_sessions_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @session.errors } }
            end
          end
        end

        def update
          if @session.update(session_params)
            redirect_to admin_conferences_sessions_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @session.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @session.errors } }
            end
          end
        end

        def destroy
          if @session.destroy
            redirect_to admin_conferences_sessions_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @session.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @session.errors } }
            end
          end
        end

        private

        def set_session
          @session = Session.find params[:id]
        end

        def set_conferences
          @conferences = Conference.all.to_json methods: [:name], include: { presentation_types: { methods: [:name] } }
        end

        def set_institutions
          @institutions = Institution.all.to_json methods: [:name], include: { rooms: { methods: [:name] } }
        end

        def set_breadcrumbs
          add_breadcrumb Conference.model_name.human(count: 0), admin_conferences_conferences_path
          add_breadcrumb Session.model_name.human(count: 0), admin_conferences_sessions_path
        end

        def set_tabs
          @tabs = %w[session_details presentations]
        end

        def session_params
          params.require(:admin_conferences_session).permit(:name, :presentation_type_id, :room_id)
        end
      end
    end
  end
end
