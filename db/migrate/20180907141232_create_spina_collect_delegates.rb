class CreateSpinaCollectDelegates < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_delegates do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :url
      t.belongs_to :institution

      t.timestamps null: false
    end
  end
end
