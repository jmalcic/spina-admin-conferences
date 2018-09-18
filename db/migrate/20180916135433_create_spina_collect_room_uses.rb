# frozen_string_literal: true

class CreateSpinaCollectRoomUses < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_room_uses do |t|
      t.belongs_to :room_possession,
                   foreign_key: { to_table: :spina_collect_room_possessions }
      t.belongs_to :presentation_type,
                   foreign_key: { to_table: :spina_collect_presentation_types }
    end
  end
end
