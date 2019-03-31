# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class shows room uses
      class RoomUsesController < ::Spina::Admin::AdminController
        include ::Spina::Conferences

        def index
          begin
            @room_uses = PresentationType.find(params[:presentation_type_id]).room_uses
          rescue ActiveRecord::RecordNotFound
            @room_uses = RoomUse.all
          end
          respond_to { |format| format.json { render json: @room_uses, methods: :room_name } }
        end
      end
    end
  end
end
