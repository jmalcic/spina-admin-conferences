# frozen_string_literal: true

class RenameSpinaConferencesConferenceDelegates < ActiveRecord::Migration[6.0]
  def change
    rename_table :spina_conferences_conferences_delegates, :spina_conferences_delegations
    rename_column :spina_conferences_delegations, :spina_conferences_conference_id, :conference_id
    rename_column :spina_conferences_delegations, :spina_conferences_delegate_id, :delegate_id
    change_table :spina_conferences_delegations do |t|
      t.column :id, :primary_key
    end
  end
end
