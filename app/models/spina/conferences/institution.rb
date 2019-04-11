# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents institutions where a conference takes place.
    class Institution < ApplicationRecord
      belongs_to :logo, class_name: 'Spina::Image', optional: true

      has_many :conferences, autosave: true
      has_many :rooms, dependent: :destroy
      has_many :room_posessions, through: :rooms
      has_many :delegates, dependent: :destroy

      accepts_nested_attributes_for :rooms

      validates :name, :city, presence: true

      def self.import(file)
        InstitutionImportJob.perform_later IO.read(file)
      end
    end
  end
end
