class CreateSpinaCollectInstitutions < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_institutions do |t|
      t.string :name
      t.string :city

      t.timestamps null: false
    end
  end
end
