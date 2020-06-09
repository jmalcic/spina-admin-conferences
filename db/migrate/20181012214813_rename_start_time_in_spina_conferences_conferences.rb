# frozen_string_literal: true

class RenameStartTimeInSpinaConferencesConferences < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    rename_column :spina_conferences_presentations, :start_time, :start_datetime
  end
end
