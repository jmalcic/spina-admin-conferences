class CreateSpinaCollectConferences < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_conferences do |t|
      t.daterange :dates
      t.belongs_to :institution

      t.timestamps null: false
    end
  end
end
