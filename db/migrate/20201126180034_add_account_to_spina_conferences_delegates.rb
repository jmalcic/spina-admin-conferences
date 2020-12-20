# frozen_string_literal: true

class AddAccountToSpinaConferencesDelegates < ActiveRecord::Migration[6.0]
  def change
    add_reference :spina_conferences_delegates, :account, foreign_key: { to_table: :spina_conferences_accounts }
  end
end
