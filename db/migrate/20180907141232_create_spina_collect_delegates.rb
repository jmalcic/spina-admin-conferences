# frozen_string_literal: true

class CreateSpinaCollectDelegates < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_delegates do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :url
      t.belongs_to :institution,
                   foreign_key: { to_table: :spina_collect_institutions }

      t.timestamps null: false
    end
  end
end
