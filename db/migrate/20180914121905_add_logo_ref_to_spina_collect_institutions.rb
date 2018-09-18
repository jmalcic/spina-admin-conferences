# frozen_string_literal: true

class AddLogoRefToSpinaCollectInstitutions < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    add_reference :spina_collect_institutions, :logo,
                  foreign_key: { to_table: :spina_images }
  end
end
