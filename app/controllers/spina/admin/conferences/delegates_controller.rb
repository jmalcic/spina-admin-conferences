# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages delegates and sets breadcrumbs
      class DelegatesController < ::Spina::Admin::AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @delegates =
            if params[:institution_id]
              Spina::Conferences::Institution.find(params[:institution_id]).delegates.sorted
            else
              Spina::Conferences::Delegate.sorted
            end
        end

        def new
          @delegate = Spina::Conferences::Delegate.new
          add_breadcrumb I18n.t('spina.conferences.delegates.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @delegate = Spina::Conferences::Delegate.find params[:id]
          add_breadcrumb "#{@delegate.first_name} #{@delegate.last_name}"
          render layout: 'spina/admin/admin'
        end

        def create
          @delegate = Spina::Conferences::Delegate.new delegate_params
          add_breadcrumb I18n.t('spina.conferences.delegates.new')
          if @delegate.save
            redirect_to admin_conferences_delegates_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @delegate = Spina::Conferences::Delegate.find params[:id]
          add_breadcrumb "#{@delegate.first_name} #{@delegate.last_name}"
          if @delegate.update(delegate_params)
            redirect_to admin_conferences_delegates_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @delegate = Spina::Conferences::Delegate.find params[:id]
          @delegate.destroy
          if Delegate.any? || DietaryRequirement.any? || Conference.any?
            redirect_to admin_conferences_delegates_path
          else
            redirect_to admin_conferences_conferences_path
          end
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.delegates'), admin_conferences_delegates_path
        end

        def set_tabs
          @tabs = %w{delegate_details conferences presentations}
        end

        def delegate_params
          params.require(:delegate).permit(:first_name, :last_name,
                                           :email_address, :url,
                                           :institution_id,
                                           conference_ids: [],
                                           dietary_requirement_ids: [])
        end
      end
    end
  end
end
