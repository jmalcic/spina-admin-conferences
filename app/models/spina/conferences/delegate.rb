# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conference delegates.
    class Delegate < ApplicationRecord
      belongs_to :institution, inverse_of: :delegates
      has_and_belongs_to_many :conferences, foreign_key: :spina_conferences_delegate_id,
                                            association_foreign_key: :spina_conferences_conference_id
      has_and_belongs_to_many :presentations, foreign_key: :spina_conferences_delegate_id,
                                              association_foreign_key: :spina_conferences_presentation_id
      has_and_belongs_to_many :dietary_requirements, foreign_key: :spina_conferences_delegate_id,
                                                     association_foreign_key: :spina_conferences_dietary_requirement_id

      validates :first_name, :last_name, :conferences, presence: true
      validates :email_address, 'spina/conferences/email_address': true
      validates :url, 'spina/conferences/http_url': true

      scope :sorted, -> { order :last_name, :first_name }

      def self.import(file)
        DelegateImportJob.perform_later IO.read(file)
      end

      # Returns first name and last name, used to address delegates.
      def full_name
        "#{first_name} #{last_name}"
      end

      # Returns full name and institution, used to identify delegates.
      def full_name_and_institution
        "#{full_name}, #{institution.name}"
      end

      # Returns last name and first name, used for sorting delegates.
      def reversed_name
        "#{last_name}, #{first_name}"
      end

      # Returns reversed name and institution, used for sorting delegates.
      def reversed_name_and_institution
        "#{reversed_name}, #{institution.name}"
      end
    end
  end
end
