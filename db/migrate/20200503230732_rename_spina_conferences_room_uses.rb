# frozen_string_literal: true

class RenameSpinaConferencesRoomUses < ActiveRecord::Migration[6.0] #:nodoc:
  def change
    rename_table :spina_conferences_room_uses, :spina_conferences_sessions
    rename_column :spina_conferences_presentations, :room_use_id, :session_id
  end
end
