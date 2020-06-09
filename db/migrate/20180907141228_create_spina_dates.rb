# frozen_string_literal: true

class CreateSpinaDates < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_table :spina_dates do |t|
      t.date :content

      t.timestamps null: false
    end
  end
end
