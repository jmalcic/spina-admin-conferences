module Spina
  module Admin
    # This class manages presentation types
    class PresentationTypesController < AdminController
      before_action :set_breadcrumbs, except: :index

      layout 'spina/admin/presentations'

      def index
        @presentation_types = PresentationType.sorted
        add_breadcrumb t('spina.website.presentations')
      end

      def new
        @presentation_type = PresentationType.new
        add_breadcrumb I18n.t('spina.presentation_types.new')
        render layout: 'spina/admin/admin'
      end

      def edit
        @presentation_type = PresentationType.find(params[:id])
        add_breadcrumb @presentation_type.name
        render layout: 'spina/admin/admin'
      end

      def create
        @presentation_type = PresentationType.new(presentation_type_params)
        add_breadcrumb I18n.t('spina.presentation_types.new')
        if @presentation_type.save
          redirect_to admin_presentation_types_path
        else
          render :new, layout: 'spina/admin/admin'
        end
      end

      def update
        @presentation_type = PresentationType.find(params[:id])
        add_breadcrumb @presentation_type.name
        if @presentation_type.update(presentation_type_params)
          redirect_to admin_presentation_types_path
        else
          render :edit, layout: 'spina/admin/admin'
        end
      end

      def destroy
        @presentation_type = PresentationType.find(params[:id])
        @presentation_type.destroy
        if PresentationType.any? || Presentation.any? || Delegate.any?
          redirect_to admin_presentation_types_path
        elsif Delegate.any? || DietaryRequirement.any? || Conference.any?
          redirect_to admin_delegates_path
        else
          redirect_to admin_conferences_path
        end
      end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('spina.website.presentations'), admin_presentations_path
      end

      def presentation_type_params
        params.require(:presentation_type).permit(:name, :minutes)
      end
    end
  end
end
