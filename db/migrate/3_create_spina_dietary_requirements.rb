class CreateSpinaDietaryRequirements < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_dietary_requirements do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
