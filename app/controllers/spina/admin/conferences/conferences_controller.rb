# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages conferences and sets breadcrumbs
      class ConferencesController < ApplicationController
        before_action :set_conference, only: %i[edit update destroy]
        before_action :set_conferences_breadcrumb
        before_action :set_tabs
        before_action :set_institutions, only: %i[new edit]

        def index
          @conferences = Conference.sorted
        end

        def new
          @conference = Conference.new
          add_breadcrumb I18n.t('spina.conferences.conferences.new')
        end

        def edit
          add_breadcrumb @conference.name
        end

        def create
          @conference = Conference.new(conference_params)

          if @conference.save
            redirect_to admin_conferences_conferences_path, success: t('spina.conferences.conferences.saved')
          else
            add_breadcrumb I18n.t('spina.conferences.conferences.new')
            render :new
          end
        end

        def update
          if @conference.update(conference_params)
            redirect_to admin_conferences_conferences_path, success: t('spina.conferences.conferences.saved')
          else
            add_breadcrumb @conference.name
            render :edit
          end
        end

        def destroy
          @conference.destroy
          if @conference.destroy
            redirect_to admin_conferences_conferences_path, success: t('spina.conferences.conferences.destroyed')
          else
            add_breadcrumb @conference.name
            render :edit
          end
        end

        private

        def set_conference
          @conference = Conference.find params[:id]
        end

        def set_institutions
          @institutions = Institution.all.to_json include: { rooms: { methods: [:name] } }
        end

        def set_conferences_breadcrumb
          add_breadcrumb Conference.model_name.human(count: 0), admin_conferences_conferences_path
        end

        def set_tabs
          @tabs = %w[conference_details delegates presentation_types rooms presentations]
        end

        def conference_params
          params.require(:admin_conferences_conference).permit(:start_date, :finish_date, :name)
        end
      end
    end
  end
end
