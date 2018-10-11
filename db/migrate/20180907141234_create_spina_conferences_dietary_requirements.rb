# frozen_string_literal: true

class CreateSpinaConferencesDietaryRequirements < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_conferences_dietary_requirements do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
