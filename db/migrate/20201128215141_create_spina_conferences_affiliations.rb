# frozen_string_literal: true

class CreateSpinaConferencesAffiliations < ActiveRecord::Migration[6.0]
  def change
    create_table :spina_conferences_affiliations do |t|
      t.references :account, null: false, foreign_key: { to_table: :spina_conferences_accounts }
      t.references :institution, null: false, foreign_key: { to_table: :spina_conferences_institutions }

      t.timestamps null: false
    end
  end
end
