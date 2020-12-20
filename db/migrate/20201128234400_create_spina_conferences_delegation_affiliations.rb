# frozen_string_literal: true

class CreateSpinaConferencesDelegationAffiliations < ActiveRecord::Migration[6.0]
  def change
    create_table :spina_conferences_delegation_affiliations do |t|
      t.references :delegation, null: false, foreign_key: { to_table: :spina_conferences_delegations },
                                index: { name: 'index_spina_conferences_delegation_affiliations_on_delegation' }
      t.references :institution, null: false, foreign_key: { to_table: :spina_conferences_institutions },
                                 index: { name: 'index_spina_conferences_delegation_affiliations_on_institution' }

      t.timestamps
    end
  end
end
