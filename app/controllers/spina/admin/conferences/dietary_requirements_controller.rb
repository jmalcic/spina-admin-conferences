# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages dietary requirements
      class DietaryRequirementsController < ApplicationController
        before_action :set_dietary_requirement, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs

        def index
          @dietary_requirements = DietaryRequirement.sorted
        end

        def new
          @dietary_requirement = DietaryRequirement.new
          add_breadcrumb I18n.t('spina.conferences.dietary_requirements.new')
        end

        def edit
          add_breadcrumb @dietary_requirement.name
        end

        def create
          @dietary_requirement = DietaryRequirement.new dietary_requirement_params

          if @dietary_requirement.save
            redirect_to admin_conferences_dietary_requirements_path, success: t('spina.conferences.dietary_requirements.saved')
          else
            add_breadcrumb t('spina.conferences.dietary_requirements.new')
            render :new
          end
        end

        def update
          if @dietary_requirement.update(dietary_requirement_params)
            redirect_to admin_conferences_dietary_requirements_path, success: t('spina.conferences.dietary_requirements.saved')
          else
            add_breadcrumb @dietary_requirement.name
            render :edit
          end
        end

        def destroy
          if @dietary_requirement.destroy
            redirect_to admin_conferences_dietary_requirements_path, success: t('spina.conferences.dietary_requirements.destroyed')
          else
            add_breadcrumb @dietary_requirement.name
            render :edit
          end
        end

        private

        def set_dietary_requirement
          @dietary_requirement = DietaryRequirement.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb DietaryRequirement.model_name.human(count: 0), admin_conferences_dietary_requirements_path
        end

        def set_tabs
          @tabs = %w[dietary_requirement_details delegates]
        end

        def dietary_requirement_params
          params.require(:admin_conferences_dietary_requirement).permit(:name)
        end
      end
    end
  end
end
