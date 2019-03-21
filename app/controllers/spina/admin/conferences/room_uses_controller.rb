# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class shows room uses
      class RoomUsesController < ::Spina::Admin::AdminController
        def index
          @room_uses = Spina::Conferences::PresentationType.find(params[:presentation_type_id]).room_uses
          respond_to do |format|
            format.html
            format.json { render json: @room_uses, methods: :room_name }
          end
        end
      end
    end
  end
end
