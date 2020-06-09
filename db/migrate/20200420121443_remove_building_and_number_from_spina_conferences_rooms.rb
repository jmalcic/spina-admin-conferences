# frozen_string_literal: true

class RemoveBuildingAndNumberFromSpinaConferencesRooms < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    remove_column :spina_conferences_rooms, :building, :string, null: false
    remove_column :spina_conferences_rooms, :number, :string, null: false
  end
end
