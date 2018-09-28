module Spina
  module Admin
    module Collect
      # This class manages rooms and sets breadcrumbs
      class RoomsController < AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        layout 'spina/admin/collect/institutions'

        def index
          @rooms =
            if params[:institution_id]
              Spina::Collect::Institution.find(params[:institution_id])
                .rooms
            elsif params[:presentation_type_id]
              Spina::Collect::PresentationType.find(params[:presentation_type_id])
                .rooms
            else
              Spina::Collect::Room.all
            end
        end

        def new
          @room = Spina::Collect::Room.new
          add_breadcrumb I18n.t('spina.collect.rooms.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @room = Spina::Collect::Room.find params[:id]
          add_breadcrumb @room.building_and_number
          render layout: 'spina/admin/admin'
        end

        def create
          @room = Spina::Collect::Room.new(conference_params)
          add_breadcrumb I18n.t('spina.collect.rooms.new')
          if @room.save
            redirect_to admin_collect_rooms_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @room = Spina::Collect::Room.find params[:id]
          add_breadcrumb @room.building_and_number
          if @room.update(conference_params)
            redirect_to admin_collect_rooms_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @room = Spina::Collect::Room.find params[:id]
          @room.destroy
          redirect_to admin_collect_rooms_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.collect.website.institutions'), admin_collect_institutions_path
          add_breadcrumb I18n.t('spina.collect.website.rooms'), admin_collect_rooms_path
        end

        def set_tabs
          @tabs = %w{room_details presentations}
        end

        def conference_params
          params.require(:room).permit(:building, :number, :institution_id)
        end
      end
    end
  end
end
