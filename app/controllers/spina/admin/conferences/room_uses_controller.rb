# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class shows room uses
      class RoomUsesController < ::Spina::Admin::AdminController
        def index
          begin
            @room_uses = Spina::Conferences::PresentationType.find(params[:presentation_type_id]).room_uses
          rescue ActiveRecord::RecordNotFound
            @room_uses = Spina::Conferences::RoomUse.all
          end
          respond_to { |format| format.json { render json: @room_uses, methods: :room_name } }
        end
      end
    end
  end
end
