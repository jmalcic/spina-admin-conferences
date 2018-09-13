class CreateSpinaCollectRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_rooms do |t|
      t.string :number
      t.string :building
      t.belongs_to :institution

      t.timestamps null: false
    end
  end
end
