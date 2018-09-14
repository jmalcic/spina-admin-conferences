module Spina
  module Admin
    module Collect
      # This class manages institutions and sets breadcrumbs
      class InstitutionsController < AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: [:new, :create, :edit, :update]

        def index
          @institutions = Spina::Collect::Institution.all
        end

        def new
          @institution = Spina::Collect::Institution.new
          add_breadcrumb I18n.t('spina.collect.institutions.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @institution = Spina::Collect::Institution.find params[:id]
          add_breadcrumb @institution.name
          render layout: 'spina/admin/admin'
        end

        def create
          @institution = Spina::Collect::Institution.new(conference_params)
          add_breadcrumb I18n.t('spina.collect.institutions.new')
          if @institution.save
            redirect_to admin_collect_institutions_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @institution = Spina::Collect::Institution.find params[:id]
          add_breadcrumb @institution.name
          if @institution.update(conference_params)
            redirect_to admin_collect_institutions_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @institution = Spina::Collect::Institution.find params[:id]
          @institution.destroy
          redirect_to admin_collect_institutions_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.collect.website.institutions'), admin_collect_institutions_path
        end

        def set_tabs
          @tabs = %w{institution_details rooms conferences delegates}
        end

        def conference_params
          params.require(:institution).permit(:name, :city, :logo_id)
        end
      end
    end
  end
end
