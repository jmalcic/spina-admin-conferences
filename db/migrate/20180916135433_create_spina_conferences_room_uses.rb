# frozen_string_literal: true

class CreateSpinaConferencesRoomUses < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_conferences_room_uses do |t|
      t.references :room_possession, foreign_key: { to_table: :spina_conferences_room_possessions }
      t.references :presentation_type, foreign_key: { to_table: :spina_conferences_presentation_types }
    end
  end
end
