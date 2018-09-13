class CreateSpinaCollectConferencePageParts < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_collect_conference_page_parts do |t|
      t.string :title
      t.string :name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.belongs_to :conference_page
      t.integer :conference_page_partable_id
      t.string :conference_page_partable_type

      t.timestamps
    end
  end
end
