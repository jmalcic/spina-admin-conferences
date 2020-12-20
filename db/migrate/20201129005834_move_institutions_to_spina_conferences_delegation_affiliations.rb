# frozen_string_literal: true

class MoveInstitutionsToSpinaConferencesDelegationAffiliations < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        Spina::Admin::Conferences::Delegation.in_batches.each_record do |delegation|
          Spina::Admin::Conferences::DelegationAffiliation.create(delegation_id: delegation.id, institution_id: delegation.institution_id)
        end
        remove_reference :spina_conferences_delegations, :institution,
                         foreign_key: { to_table: :spina_conferences_institutions }
      end
      dir.down do
        add_reference :spina_conferences_delegations, :institution,
                      foreign_key: { to_table: :spina_conferences_institutions }
        Spina::Admin::Conferences::Delegation.reset_column_information
        Spina::Admin::Conferences::Delegation.in_batches.each_record do |delegation|
          Spina::Admin::Conferences::DelegationAffiliation
            .find_by(delegation_id: delegation.id)
            .then { |delegation_affiliation| delegation.update(institution_id: delegation_affiliation.institution_id) }
        end
      end
    end
  end
end
