# frozen_string_literal: true

class CreateSpinaCollectRoomPossessions < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_room_possessions do |t|
      t.belongs_to :room, foreign_key: { to_table: :spina_collect_rooms }
      t.belongs_to :conference,
                   foreign_key: { to_table: :spina_collect_conferences }
    end
  end
end
