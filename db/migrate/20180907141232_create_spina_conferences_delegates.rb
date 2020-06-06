# frozen_string_literal: true

class CreateSpinaConferencesDelegates < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_conferences_delegates do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :url
      t.references :institution, foreign_key: { to_table: :spina_conferences_institutions }

      t.timestamps null: false
    end
  end
end
