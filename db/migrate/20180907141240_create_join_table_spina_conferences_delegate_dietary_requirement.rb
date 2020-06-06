# frozen_string_literal: true

class CreateJoinTableSpinaConferencesDelegateDietaryRequirement < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_join_table :spina_conferences_delegates, :spina_conferences_dietary_requirements
  end
end
