class CreateJoinTableSpinaCollectConferenceDelegate < ActiveRecord::Migration[5.2]
  def change
    create_join_table :spina_collect_conferences, :spina_collect_delegates
  end
end