# frozen_string_literal: true

class CreateSpinaConferencesPresentationAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :spina_conferences_presentation_attachments do |t|
      t.belongs_to :presentation,
                   null: false, foreign_key: { to_table: :spina_conferences_presentations, on_delete: :cascade },
                   index: { name: 'index_conferences_presentation_attachments_on_presentation_id' }
      t.belongs_to :presentation_attachment_type,
                   null: false, foreign_key: { to_table: :spina_conferences_presentation_attachment_types, on_delete: :cascade },
                   index: { name: 'index_conferences_presentation_attachments_on_type_id' }

      t.timestamps null: false
    end
  end
end
