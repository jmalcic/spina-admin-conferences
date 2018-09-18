# frozen_string_literal: true

class CreateSpinaCollectConferences < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_conferences do |t|
      t.daterange :dates
      t.belongs_to :institution,
                   foreign_key: { to_table: :spina_collect_institutions }

      t.timestamps null: false
    end
  end
end
