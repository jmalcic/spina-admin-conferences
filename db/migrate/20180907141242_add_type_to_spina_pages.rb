class AddTypeToSpinaPages < ActiveRecord::Migration[5.2]
  def change
    add_column :spina_pages, :type, :string
  end
end
