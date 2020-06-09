# frozen_string_literal: true

class CreateSpinaConferencesRooms < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_table :spina_conferences_rooms do |t|
      t.string :number
      t.string :building
      t.references :institution, foreign_key: { to_table: :spina_conferences_institutions }

      t.timestamps null: false
    end
  end
end
