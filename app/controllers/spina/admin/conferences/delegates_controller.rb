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
          add_breadcrumb t('.new')
        end

        def edit
          add_breadcrumb @delegate.full_name
        end

        def create
          @delegate = Delegate.new(delegate_params)

          if @delegate.save
            redirect_to admin_conferences_delegates_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @delegate.errors } }
            end
          end
        end

        def update
          if @delegate.update(delegate_params)
            redirect_to admin_conferences_delegates_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @delegate.full_name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @delegate.errors } }
            end
          end
        end

        def destroy
          if @delegate.destroy
            redirect_to admin_conferences_delegates_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @delegate.full_name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @delegate.errors } }
            end
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
