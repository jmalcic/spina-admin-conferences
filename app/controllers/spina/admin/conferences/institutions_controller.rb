# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages institutions and sets breadcrumbs
      class InstitutionsController < ::Spina::Admin::AdminController
        include ::Spina::Conferences

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @institutions = Institution.all
        end

        def new
          @institution = Institution.new
          add_breadcrumb I18n.t('spina.conferences.institutions.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @institution = Institution.find params[:id]
          add_breadcrumb @institution.name
          render layout: 'spina/admin/admin'
        end

        def create
          @institution = Institution.new(conference_params)
          add_breadcrumb I18n.t('spina.conferences.institutions.new')
          if @institution.save
            redirect_to admin_conferences_institutions_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @institution = Institution.find params[:id]
          add_breadcrumb @institution.name
          if @institution.update(conference_params)
            redirect_to admin_conferences_institutions_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @institution = Institution.find params[:id]
          @institution.destroy
          redirect_to admin_conferences_institutions_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.institutions'), admin_conferences_institutions_path
        end

        def set_tabs
          @tabs = %w[institution_details rooms conferences delegates]
        end

        def conference_params
          params.require(:institution).permit(:name, :city, :logo_id)
        end
      end
    end
  end
end
