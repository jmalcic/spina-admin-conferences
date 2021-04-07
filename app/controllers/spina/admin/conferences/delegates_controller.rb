# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Controller for {Delegate} objects.
      # @see Delegate
      class DelegatesController < ApplicationController
        before_action :set_delegate, only: %i[edit update destroy]
        before_action :set_breadcrumb
        before_action :set_tabs

        # @!group Actions

        # Renders a list of delegates.
        # @return [void]
        def index
          @delegates = Delegate.sorted
        end

        # Renders a form for a new delegate.
        # @return [void]
        def new
          @delegate = Delegate.new
          add_breadcrumb t('.new')
        end

        # Renders a form for an existing delegate.
        # @return [void]
        def edit
          add_breadcrumb @delegate.full_name
        end

        # Creates a delegate.
        # @return [void]
        def create # rubocop:disable Metrics/MethodLength
          @delegate = Delegate.new(delegate_params)

          if @delegate.save
            redirect_to admin_conferences_delegates_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @delegate.errors } }
            end
          end
        end

        # Updates a delegate.
        # @return [void]
        def update # rubocop:disable Metrics/MethodLength
          if @delegate.update(delegate_params)
            redirect_to admin_conferences_delegates_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @delegate.full_name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @delegate.errors } }
            end
          end
        end

        # Destroys a delegate.
        # @return [void]
        def destroy # rubocop:disable Metrics/MethodLength
          if @delegate.destroy
            redirect_to admin_conferences_delegates_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @delegate.full_name
                render :edit
              end
              format.turbo_stream { render partial: 'errors', locals: { errors: @delegate.errors } }
            end
          end
        end

        # Imports a delegate.
        # @return [void]
        # @see Delegate#import
        def import
          Delegate.import params[:file]
        end

        # @!endgroup

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
          params.require(:delegate).permit(:first_name, :last_name, :email_address, :url, :institution_id,
                                           conference_ids: [], dietary_requirement_ids: [])
        end
      end
    end
  end
end
