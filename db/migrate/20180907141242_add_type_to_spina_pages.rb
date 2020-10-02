# frozen_string_literal: true

class AddTypeToSpinaPages < ActiveRecord::Migration[5.2] #:nodoc:
  def change
    add_column :spina_pages, :type, :string
  end
end
