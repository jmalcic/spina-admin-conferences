module Spina
  module Admin
    # This class manages dietary requirements
    class DietaryRequirementsController < AdminController
      before_action :set_breadcrumbs, except: :index

      layout 'spina/admin/delegates'

      def index
        @dietary_requirements = DietaryRequirement.sorted
        add_breadcrumb I18n.t('spina.website.delegates')
      end

      def new
        @dietary_requirement = DietaryRequirement.new
        add_breadcrumb I18n.t('spina.dietary_requirements.new')
        render layout: 'spina/admin/admin'
      end

      def edit
        @dietary_requirement = DietaryRequirement.find(params[:id])
        add_breadcrumb @dietary_requirement.name
        render layout: 'spina/admin/admin'
      end

      def create
        @dietary_requirement = DietaryRequirement.new(dietary_requirement_params)
        add_breadcrumb I18n.t('spina.dietary_requirements.new')
        if @dietary_requirement.save
          redirect_to admin_dietary_requirements_path
        else
          render :new, layout: 'spina/admin/admin'
        end
      end

      def update
        @dietary_requirement = DietaryRequirement.find(params[:id])
        add_breadcrumb @dietary_requirement.name
        if @dietary_requirement.update(dietary_requirement_params)
          redirect_to admin_dietary_requirements_path
        else
          render :edit, layout: 'spina/admin/admin'
        end
      end

      def destroy
        @dietary_requirement = DietaryRequirement.find(params[:id])
        @dietary_requirement.destroy
        if DietaryRequirement.any? || Delegate.any? || Conference.any?
          redirect_to admin_dietary_requirements_path
        else
          redirect_to admin_conferences_path
        end
      end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('spina.website.delegates'), admin_delegates_path
      end

      def dietary_requirement_params
        params.require(:dietary_requirement).permit(:name,
                                                    delegate_ids: [])
      end
    end
  end
end
