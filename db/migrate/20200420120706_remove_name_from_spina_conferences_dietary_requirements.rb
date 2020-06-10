# frozen_string_literal: true

class RemoveNameFromSpinaConferencesDietaryRequirements < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    remove_column :spina_conferences_dietary_requirements, :name, :string, null: false
  end
end
