# frozen_string_literal: true

class AddJsonAttributesToSpinaConferencesConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :spina_conferences_conferences, :json_attributes, :jsonb
  end
end
