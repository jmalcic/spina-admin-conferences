# frozen_string_literal: true

module Spina
  module Collect
    # This class represents rooms in an institution.
    # A `Room` belongs to an `:institution`, and has many `:presentations`.
    # A `Room` may have many `:presentation_types`, and a
    # `PresentationType` may have many `:rooms`.
    class Room < ApplicationRecord
      belongs_to :institution
      has_and_belongs_to_many :presentation_types,
                              foreign_key: :spina_collect_room_id,
                              association_foreign_key:
                                :spina_collect_presentation_type_id
      has_many :presentations

      validates_presence_of :number, :building

      def building_and_number
        "#{building} #{number}"
      end
    end
  end
end
