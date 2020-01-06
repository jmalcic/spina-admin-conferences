# frozen_string_literal: true

class ChangeStartTimeInSpinaConferencesConferences < ActiveRecord::Migration[5.2]
  def up
    remove_column :spina_conferences_presentations, :date
    remove_column :spina_conferences_presentations, :start_time
    add_column :spina_conferences_presentations, :start_time, :datetime
  end
  def down
    remove_column :spina_conferences_presentations, :start_time
    add_column :spina_conferences_presentations, :date, :date
    add_column :spina_conferences_presentations, :start_time, :time
  end
end
