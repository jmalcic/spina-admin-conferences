# frozen_string_literal: true

class CreateSpinaConferencesRoomPossessions < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_conferences_room_possessions do |t|
      t.references :room, foreign_key: { to_table: :spina_conferences_rooms }
      t.references :conference, foreign_key: { to_table: :spina_conferences_conferences }
    end
  end
end
