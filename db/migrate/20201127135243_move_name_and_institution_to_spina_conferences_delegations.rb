# frozen_string_literal: true

class MoveNameAndInstitutionToSpinaConferencesDelegations < ActiveRecord::Migration[6.0]
  def up
    change_table :spina_conferences_delegations do |t|
      t.string :first_name
      t.string :last_name
      t.references :institution, foreign_key: { to_table: :spina_conferences_institutions, on_delete: :cascade }
    end
    Spina::Admin::Conferences::Delegate.reset_column_information
    Spina::Admin::Conferences::Delegate.in_batches.each_record do |delegate|
      delegate.delegations.each do |delegation|
        delegation.first_name = delegate.first_name
        delegation.last_name = delegate.last_name
        delegation.institution_id = delegate.institution_id
        delegation.save validate: false
      end
    end
    change_column_null :spina_conferences_delegations, :first_name, false
    change_column_null :spina_conferences_delegations, :last_name, false
    change_column_null :spina_conferences_delegations, :institution_id, false
    change_table :spina_conferences_delegates do |t|
      t.remove :first_name, :last_name
      t.remove_references :institution
    end
  end

  def down
    change_table :spina_conferences_delegates do |t|
      t.string :first_name
      t.string :last_name
      t.references :institution, foreign_key: { to_table: :spina_conferences_institutions, on_delete: :cascade }
    end
    Spina::Admin::Conferences::Delegate.reset_column_information
    Spina::Admin::Conferences::Delegate.in_batches.each_record do |delegate|
      delegate.first_name = delegate.delegations.first.first_name
      delegate.last_name = delegate.delegations.first.last_name
      delegate.institution_id = delegate.delegations.first.institution_id
      delegate.save validate: false
    end
    change_column_null :spina_conferences_delegates, :first_name, false
    change_column_null :spina_conferences_delegates, :last_name, false
    change_column_null :spina_conferences_delegates, :institution_id, false
    change_table :spina_conferences_delegations do |t|
      t.remove :first_name, :last_name
      t.remove_references :institution
    end
  end
end
