class CreateJoinTableSpinaCollectDelegateDietaryRequirement < ActiveRecord::Migration[5.2]
  def change
    create_join_table :spina_collect_delegates, :spina_collect_dietary_requirements
  end
end
