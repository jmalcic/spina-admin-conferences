module Spina
  module Admin
    module Collect
      # This class manages presentation types
      class PresentationTypesController < AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: [:new, :create, :edit, :update]

        layout 'spina/admin/collect/conferences'

        def index
          @presentation_types = Spina::Collect::PresentationType.sorted
        end

        def new
          @presentation_type = Spina::Collect::PresentationType.new
          add_breadcrumb I18n.t('spina.collect.presentation_types.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation_type = Spina::Collect::PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation_type = Spina::Collect::PresentationType.new presentation_type_params
          add_breadcrumb I18n.t('spina.collect.presentation_types.new')
          if @presentation_type.save
            redirect_to admin_collect_presentation_types_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation_type = Spina::Collect::PresentationType.find params[:id]
          add_breadcrumb @presentation_type.name
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_collect_presentation_types_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation_type = Spina::Collect::PresentationType.find params[:id]
          @presentation_type.destroy
          if Spina::Collect::PresentationType.any? || Spina::Collect::Presentation.any? || Spina::Collect::Delegate.any?
            redirect_to admin_collect_presentation_types_path
          elsif Spina::Collect::Delegate.any? || Spina::Collect::DietaryRequirement.any? || Spina::Collect::Conference.any?
            redirect_to admin_collect_delegates_path
          else
            redirect_to admin_collect_conferences_path
          end
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.collect.website.conferences'), admin_collect_conferences_path
          add_breadcrumb I18n.t('spina.collect.website.presentation_types'), admin_collect_presentation_types_path
        end

        def set_tabs
          @tabs = %w{presentation_type_details presentations rooms}
        end

        def presentation_type_params
          params.require(:presentation_type).permit(:name, :minutes,
                                                    :conference_id,
                                                    room_ids: [])
        end
      end
    end
  end
end
