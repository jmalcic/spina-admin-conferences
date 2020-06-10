# frozen_string_literal: true

class CreateSpinaConferencesParts < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    create_table :spina_conferences_parts do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :title
      t.string :name
      t.references :partable, polymorphic: true, index: false
      t.references :pageable, polymorphic: true, index: false
    end
  end
end
