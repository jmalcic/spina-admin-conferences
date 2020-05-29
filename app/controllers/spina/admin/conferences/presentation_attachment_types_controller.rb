# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages dietary requirements
      class PresentationAttachmentTypesController < ::Spina::Admin::AdminController
        before_action :set_breadcrumbs

        layout 'spina/admin/conferences/presentation_attachment_types'

        def index
          @presentation_attachment_types = PresentationAttachmentType.sorted
        end

        def new
          @presentation_attachment_type = PresentationAttachmentType.new
          add_breadcrumb I18n.t('spina.conferences.presentation_attachment_types.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @presentation_attachment_type = PresentationAttachmentType.find params[:id]
          add_breadcrumb @presentation_attachment_type.name
          render layout: 'spina/admin/admin'
        end

        def create
          @presentation_attachment_type = PresentationAttachmentType.new presentation_attachment_type_params
          add_breadcrumb I18n.t('spina.conferences.presentation_attachment_types.new')
          if @presentation_attachment_type.save
            redirect_to admin_conferences_presentation_attachment_types_path,
                        flash: { success: t('spina.conferences.presentation_attachment_types.saved') }
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @presentation_attachment_type = PresentationAttachmentType.find params[:id]
          add_breadcrumb @presentation_attachment_type.name
          if @presentation_attachment_type.update(presentation_attachment_type_params)
            redirect_to admin_conferences_presentation_attachment_types_path,
                        flash: { success: t('spina.conferences.presentation_attachment_types.saved') }
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @presentation_attachment_type = PresentationAttachmentType.find params[:id]
          @presentation_attachment_type.destroy
          redirect_to admin_conferences_presentation_attachment_types_path,
                      flash: { success: t('spina.conferences.presentation_attachment_types.destroyed') }
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.presentation_attachment_types'),
                         admin_conferences_presentation_attachment_types_path
        end

        def presentation_attachment_type_params
          params.require(:admin_conferences_presentation_attachment_type).permit(:name)
        end
      end
    end
  end
end
