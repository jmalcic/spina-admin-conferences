# frozen_string_literal: true

class CreateSpinaCollectInstitutions < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_institutions do |t|
      t.string :name
      t.string :city

      t.timestamps null: false
    end
  end
end
