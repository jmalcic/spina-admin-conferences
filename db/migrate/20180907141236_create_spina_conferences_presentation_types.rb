# frozen_string_literal: true

class CreateSpinaConferencesPresentationTypes < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_table :spina_conferences_presentation_types do |t|
      t.string :name
      t.interval :duration
      t.references :conference, foreign_key: { to_table: :spina_conferences_conferences }

      t.timestamps null: false
    end
  end
end
