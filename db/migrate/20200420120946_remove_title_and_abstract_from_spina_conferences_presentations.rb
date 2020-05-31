# frozen_string_literal: true

class RemoveTitleAndAbstractFromSpinaConferencesPresentations < ActiveRecord::Migration[6.0] #:nodoc:
  def change
    remove_column :spina_conferences_presentations, :title, :string, null: false
    remove_column :spina_conferences_presentations, :abstract, :text, null: false
  end
end
