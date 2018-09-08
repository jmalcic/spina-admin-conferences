class CreateSpinaCollectPresentationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_presentation_types do |t|
      t.string :name
      t.interval :duration
      t.belongs_to :conference

      t.timestamps null: false
    end
  end
end
