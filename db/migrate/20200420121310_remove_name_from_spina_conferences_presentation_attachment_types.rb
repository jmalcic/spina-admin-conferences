# frozen_string_literal: true

class RemoveNameFromSpinaConferencesPresentationAttachmentTypes < ActiveRecord::Migration[6.0] #:nodoc:
  def change
    remove_column :spina_conferences_presentation_attachment_types, :name, :string, null: false
  end
end
