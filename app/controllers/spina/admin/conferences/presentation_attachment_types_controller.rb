# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentation attachment types
      class PresentationAttachmentTypesController < ApplicationController
        before_action :set_presentation_attachment_type, only: %i[edit update destroy]
        before_action :set_breadcrumb

        def index
          @presentation_attachment_types = PresentationAttachmentType.sorted
        end

        def new
          @presentation_attachment_type = PresentationAttachmentType.new
          add_breadcrumb I18n.t('spina.conferences.presentation_attachment_types.new')
        end

        def edit
          add_breadcrumb @presentation_attachment_type.name
        end

        def create
          @presentation_attachment_type = PresentationAttachmentType.new presentation_attachment_type_params

          if @presentation_attachment_type.save
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('spina.conferences.presentation_attachment_types.saved')
          else
            add_breadcrumb I18n.t('spina.conferences.presentation_attachment_types.new')
            render :new
          end
        end

        def update
          if @presentation_attachment_type.update(presentation_attachment_type_params)
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('spina.conferences.presentation_attachment_types.saved')
          else
            add_breadcrumb @presentation_attachment_type.name
            render :edit
          end
        end

        def destroy
          if @presentation_attachment_type.destroy
            redirect_to admin_conferences_presentation_attachment_types_path, success: t('spina.conferences.presentation_attachment_types.destroyed')
          else
            add_breadcrumb @presentation_attachment_type.name
            render :edit
          end
        end

        private

        def set_presentation_attachment_type
          @presentation_attachment_type = PresentationAttachmentType.find params[:id]
        end

        def set_breadcrumb
          add_breadcrumb PresentationAttachmentType.model_name.human(count: 0),
                         admin_conferences_presentation_attachment_types_path
        end

        def presentation_attachment_type_params
          params.require(:admin_conferences_presentation_attachment_type).permit(:name)
        end
      end
    end
  end
end
