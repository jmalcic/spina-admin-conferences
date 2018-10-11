# frozen_string_literal: true

class CreateJoinTableSpinaConferencesDelegatePresentation < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_join_table :spina_conferences_delegates, :spina_conferences_presentations
  end
end
