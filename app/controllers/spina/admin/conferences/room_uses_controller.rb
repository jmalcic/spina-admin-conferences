module Spina
  module Admin
    module Conferences
      # This class shows room uses
      class RoomUsesController < ::Spina::Admin::AdminController
        def index
          @room_uses = Spina::Conferences::PresentationType.find(
            params[:presentation_type_id]
          ).room_uses
        end
      end
    end
  end
end
