# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages institutions and sets breadcrumbs
      class InstitutionsController < ApplicationController
        before_action :set_institution, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs

        def index
          @institutions = Institution.all
        end

        def new
          @institution = Institution.new
          add_breadcrumb t('spina.conferences.institutions.new')
        end

        def edit
          add_breadcrumb @institution.name
        end

        def create
          @institution = Institution.new(conference_params)

          if @institution.save
            redirect_to admin_conferences_institutions_path, success: t('spina.conferences.institutions.saved')
          else
            add_breadcrumb t('spina.conferences.institutions.new')
            render :new
          end
        end

        def update
          if @institution.update(conference_params)
            redirect_to admin_conferences_institutions_path, success: t('spina.conferences.institutions.saved')
          else
            add_breadcrumb @institution.name
            render :edit
          end
        end

        def destroy
          if @institution.destroy
            redirect_to admin_conferences_institutions_path, success: t('spina.conferences.institutions.destroyed')
          else
            add_breadcrumb @institution.name
            render :edit
          end
        end

        private

        def set_institution
          @institution = Institution.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb Institution.model_name.human(count: 0), admin_conferences_institutions_path
        end

        def set_tabs
          @tabs = %w[institution_details rooms delegates]
        end

        def conference_params
          params.require(:admin_conferences_institution).permit(:name, :city, :logo_id)
        end
      end
    end
  end
end
