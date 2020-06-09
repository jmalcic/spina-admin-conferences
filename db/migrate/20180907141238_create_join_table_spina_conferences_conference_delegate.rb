# frozen_string_literal: true

class CreateJoinTableSpinaConferencesConferenceDelegate < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    create_join_table :spina_conferences_conferences, :spina_conferences_delegates
  end
end
