# frozen_string_literal: true

class CreateSpinaCollectConferencePageParts < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    create_table :spina_collect_conference_page_parts do |t|
      t.belongs_to :conference_page,
                   foreign_key: { to_table: :spina_pages, on_delete: :cascade }
      t.belongs_to(
        :conference_page_partable,
        polymorphic: true,
        index: {
          name: 'index_spina_collect_parts_on_partable_type_and_partable_id'
        }
      )

      t.timestamps
    end
  end
end
