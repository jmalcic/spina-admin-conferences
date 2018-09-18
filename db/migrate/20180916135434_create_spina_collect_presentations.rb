class CreateSpinaCollectPresentations < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_presentations do |t|
      t.string :title
      t.date :date
      t.time :start_time
      t.text :abstract
      t.belongs_to :room_use,
                   foreign_key: { to_table: :spina_collect_room_uses }

      t.timestamps null: false
    end
  end
end
