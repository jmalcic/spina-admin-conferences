# frozen_string_literal: true

class CreateSpinaCollectPresentationTypes < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_presentation_types do |t|
      t.string :name
      t.interval :duration
      t.belongs_to :conference, foreign_key: { to_table: :spina_collect_conferences }

      t.timestamps null: false
    end
  end
end
