# frozen_string_literal: true

class CreateJoinTableSpinaCollectDelegatePresentation < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_join_table :spina_collect_delegates, :spina_collect_presentations
  end
end
