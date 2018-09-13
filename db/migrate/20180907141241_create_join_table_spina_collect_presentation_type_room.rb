class CreateJoinTableSpinaCollectPresentationTypeRoom < ActiveRecord::Migration[5.2]
  def change
    create_join_table :spina_collect_presentation_types, :spina_collect_rooms
  end
end
