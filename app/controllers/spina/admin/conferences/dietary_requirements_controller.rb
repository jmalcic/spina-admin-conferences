# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages dietary requirements
      class DietaryRequirementsController < ::Spina::Admin::AdminController
        include ::Spina::Conferences

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        layout 'spina/admin/conferences/delegates'

        def index
          @dietary_requirements = DietaryRequirement.sorted
        end

        def new
          @dietary_requirement = DietaryRequirement.new
          add_breadcrumb I18n.t('spina.conferences.dietary_requirements.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @dietary_requirement = DietaryRequirement.find params[:id]
          add_breadcrumb @dietary_requirement.name
          render layout: 'spina/admin/admin'
        end

        def create
          @dietary_requirement = DietaryRequirement.new dietary_requirement_params
          add_breadcrumb I18n.t('spina.conferences.dietary_requirements.new')
          if @dietary_requirement.save
            redirect_to admin_conferences_dietary_requirements_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @dietary_requirement = DietaryRequirement.find params[:id]
          add_breadcrumb @dietary_requirement.name
          if @dietary_requirement.update(dietary_requirement_params)
            redirect_to admin_conferences_dietary_requirements_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @dietary_requirement = DietaryRequirement.find params[:id]
          @dietary_requirement.destroy
          redirect_to admin_conferences_dietary_requirements_path
        end

        def import
          DietaryRequirement.import params[:file]
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.delegates'), admin_conferences_delegates_path
          add_breadcrumb I18n.t('spina.conferences.website.dietary_requirements'),
                         admin_conferences_dietary_requirements_path
        end

        def set_tabs
          @tabs = %w[dietary_requirement_details delegates]
        end

        def dietary_requirement_params
          params.require(:dietary_requirement).permit(:name)
        end
      end
    end
  end
end
