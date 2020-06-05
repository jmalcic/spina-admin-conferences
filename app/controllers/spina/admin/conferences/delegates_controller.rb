# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages delegates and sets breadcrumbs
      class DelegatesController < ApplicationController
        before_action :set_delegate, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs

        def index
          @delegates = Delegate.sorted
        end

        def new
          @delegate = Delegate.new
          add_breadcrumb I18n.t('spina.conferences.delegates.new')
        end

        def edit
          add_breadcrumb @delegate.full_name
        end

        def create
          @delegate = Delegate.new(delegate_params)

          if @delegate.save
            redirect_to admin_conferences_delegates_path, success: t('spina.conferences.delegates.saved')
          else
            add_breadcrumb I18n.t('spina.conferences.delegates.new')
            render :new
          end
        end

        def update
          if @delegate.update(delegate_params)
            redirect_to admin_conferences_delegates_path, success: t('spina.conferences.delegates.saved')
          else
            add_breadcrumb @delegate.full_name
            render :edit
          end
        end

        def destroy
          if @delegate.destroy
            redirect_to admin_conferences_delegates_path, success: t('spina.conferences.delegates.destroyed')
          else
            add_breadcrumb @delegate.full_name
            render :edit
          end
        end

        def import
          Delegate.import params[:file]
        end

        private

        def set_delegate
          @delegate = Delegate.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb Delegate.model_name.human(count: 0), admin_conferences_delegates_path
        end

        def set_tabs
          @tabs = %w[delegate_details conferences presentations]
        end

        def delegate_params
          params.require(:admin_conferences_delegate).permit(:first_name, :last_name, :email_address, :url,
                                                             :institution_id,
                                                             conference_ids: [],
                                                             dietary_requirement_ids: [])
        end
      end
    end
  end
end
