module Spina
  module Admin
    module Collect
      # This class shows room uses
      class RoomUsesController < AdminController
        def index
          @room_uses = Spina::Collect::PresentationType.find(
            params[:presentation_type_id]
          ).room_uses
          respond_to { |format| format.xml { render layout: false } }
        end
      end
    end
  end
end
