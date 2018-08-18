module Spina
  module Admin
    # This class manages presentations and sets breadcrumbs
    class PresentationsController < AdminController
      before_action :set_breadcrumbs

      def index
        @presentations = Presentation.sorted
      end

      def new
        @presentation = Presentation.new
        add_breadcrumb I18n.t('spina.presentations.new')
        render layout: 'spina/admin/admin'
      end

      def edit
        @presentation = Presentation.find(params[:id])
        add_breadcrumb @presentation.title
        render layout: 'spina/admin/admin'
      end

      def create
        @presentation = Presentation.new(presentation_params)
        add_breadcrumb I18n.t('spina.presentations.new')
        if @presentation.save
          redirect_to admin_presentations_path
        else
          render :new, layout: 'spina/admin/admin'
        end
      end

      def update
        @presentation = Presentation.find(params[:id])
        add_breadcrumb @presentation.title
        if @presentation.update(presentation_params)
          redirect_to admin_presentations_path
        else
          render :edit, layout: 'spina/admin/admin'
        end
      end

      def destroy
        @presentation = Presentation.find(params[:id])
        @presentation.destroy
        redirect_to admin_presentations_path
      end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('spina.website.presentations'),
                       admin_presentations_path
      end

      def presentation_params
        params.require(:presentation).permit(:title, :date, :start_time,
                                             :abstract, :type,
                                             :spina_conference_id,
                                             :spina_presentation_type_id,
                                             delegate_ids: [])
      end
    end
  end
end
