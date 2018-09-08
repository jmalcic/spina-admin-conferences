class CreateSpinaConferenceLists < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_conference_lists do |t|
      t.timestamps null: false
    end
  end
end
