# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class shows room uses
      class RoomUsesController < ::Spina::Admin::AdminController
        def index
          @room_uses = if params[:presentation_type_id]
                         Spina::Conferences::PresentationType.find(params[:presentation_type_id]).room_uses
                       else
                         Spina::Conferences::PresentationType.all
                       end
          respond_to do |format|
            format.html
            format.json { render json: @room_uses, methods: :room_name }
          end
        end
      end
    end
  end
end
