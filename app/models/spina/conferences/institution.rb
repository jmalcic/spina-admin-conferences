# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents institutions where a conference takes place.
    class Institution < ApplicationRecord
      belongs_to :logo, class_name: 'Spina::Image', optional: true

      has_many :conferences, inverse_of: :institution, autosave: true
      has_many :rooms, inverse_of: :institution, dependent: :destroy
      has_many :room_posessions, through: :rooms
      has_many :delegates, inverse_of: :institution, dependent: :destroy

      accepts_nested_attributes_for :rooms

      validates :name, :city, presence: true

      def self.import(file)
        InstitutionImportJob.perform_later IO.read(file)
      end
    end
  end
end
