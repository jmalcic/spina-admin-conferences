class AddLogoRefToSpinaCollectInstitutions < ActiveRecord::Migration[5.2]
  def change
    add_reference :spina_collect_institutions, :logo, foreign_key: { to_table: :spina_images }
  end
end
