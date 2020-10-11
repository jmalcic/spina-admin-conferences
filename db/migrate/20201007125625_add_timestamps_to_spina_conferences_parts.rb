# frozen_string_literal: true

class AddTimestampsToSpinaConferencesParts < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :spina_conferences_parts, default: Time.now
    change_column_default :spina_conferences_parts, :created_at, nil
    change_column_default :spina_conferences_parts, :updated_at, nil
  end
end
