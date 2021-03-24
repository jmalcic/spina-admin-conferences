# frozen_string_literal: true

class AddJsonAttributesToSpinaConferencesPresentations < ActiveRecord::Migration[6.1]
  def change
    add_column :spina_conferences_presentations, :json_attributes, :jsonb
  end
end
