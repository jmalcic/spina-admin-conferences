class CreateSpinaCollectPresentations < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_presentations do |t|
      t.string :title
      t.date :date
      t.time :start_time
      t.text :abstract
      t.belongs_to :conference
      t.belongs_to :presentation_type
      t.belongs_to :room

      t.timestamps null: false
    end
  end
end
