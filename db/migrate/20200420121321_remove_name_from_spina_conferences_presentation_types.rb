# frozen_string_literal: true

class RemoveNameFromSpinaConferencesPresentationTypes < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    remove_column :spina_conferences_presentation_types, :name, :string
  end
end
