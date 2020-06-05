# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages institutions and sets breadcrumbs
      class InstitutionsController < ApplicationController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @institutions = Institution.all
        end

        def new
          @institution = Institution.new
          add_breadcrumb I18n.t('spina.conferences.institutions.new')
        end

        def edit
          @institution = Institution.find params[:id]
          add_breadcrumb @institution.name
        end

        def create
          @institution = Institution.new(conference_params)
          add_breadcrumb I18n.t('spina.conferences.institutions.new')
          if @institution.save
            redirect_to admin_conferences_institutions_path,
                        flash: { success: t('spina.conferences.institutions.saved') }
          else
            render :new
          end
        end

        def update
          @institution = Institution.find params[:id]
          add_breadcrumb @institution.name
          if @institution.update(conference_params)
            redirect_to admin_conferences_institutions_path,
                        flash: { success: t('spina.conferences.institutions.saved') }
          else
            render :edit
          end
        end

        def destroy
          @institution = Institution.find params[:id]
          @institution.destroy
          redirect_to admin_conferences_institutions_path,
                      flash: { success: t('spina.conferences.institutions.destroyed') }
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.institutions'), admin_conferences_institutions_path
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
