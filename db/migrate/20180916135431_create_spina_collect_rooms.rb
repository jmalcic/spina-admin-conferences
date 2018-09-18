# frozen_string_literal: true

class CreateSpinaCollectRooms < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_rooms do |t|
      t.string :number
      t.string :building
      t.belongs_to :institution,
                   foreign_key: { to_table: :spina_collect_institutions }

      t.timestamps null: false
    end
  end
end
