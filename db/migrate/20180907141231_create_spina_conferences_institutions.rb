# frozen_string_literal: true

class CreateSpinaConferencesInstitutions < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_table :spina_conferences_institutions do |t|
      t.string :name
      t.string :city

      t.timestamps null: false
    end
  end
end
