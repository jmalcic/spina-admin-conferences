# frozen_string_literal: true

class CreateSpinaConferencesAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :spina_conferences_accounts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email_address, null: false
      t.boolean :unconfirmed, default: true, null: false
      t.string :password_digest, null: false
      t.string :password_reset_token, null: false

      t.index :email_address, unique: true
      t.index :password_reset_token, unique: true

      t.timestamps null: false
    end
  end
end
