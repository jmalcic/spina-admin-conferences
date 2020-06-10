# frozen_string_literal: true

class CreateSpinaEmailAddresses < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_table :spina_email_addresses do |t|
      t.string :content

      t.timestamps null: false
    end
  end
end
