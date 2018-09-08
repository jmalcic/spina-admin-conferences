# frozen_string_literal: true

module Spina
  module Collect
    # This class represents presentation types (e.g. plenaries, poster
    # presentations, etc.)
    # A presentation type has many presentations, belongs to a
    # conference, and has and belongs to many rooms.
    class PresentationType < ApplicationRecord
      belongs_to :conference
      has_many :presentations, dependent: :destroy
      has_and_belongs_to_many :rooms,
                              foreign_key: :spina_collect_presentation_type_id,
                              association_foreign_key: :spina_collect_room_id

      validates_presence_of :name, :minutes
      validates_numericality_of :minutes, greater_than_or_equal_to: 1

      scope :sorted, -> { order :name }

      def minutes
        duration / ActiveSupport::Duration::SECONDS_PER_MINUTE if duration
      end

      def minutes=(minutes)
        assign_attributes(duration: "PT#{minutes}M")
      end
    end
  end
end
