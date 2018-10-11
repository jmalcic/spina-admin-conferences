# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents conference delegates.
    # A `Delegate` may belong to multiple `:conferences`, and a `Conference`
    # may have many `:delegates`. A `Delegate` may have (present) multiple
    # `:presentations`, and a `Presentation` may have (be presented by)
    # multiple `:delegates`. A `Delegate` may have many
    # `:dietary_requirements` and conversely a `DietaryRequirement` may have
    # many `:delegates`.
    # Destroying a `Delegate` does not affect associated `:conferences` and
    # `:presentations`.
    # The format of an `:email_address` is validated.
    class Delegate < ApplicationRecord
      belongs_to :institution
      has_and_belongs_to_many :conferences,
                              foreign_key: :spina_conferences_delegate_id,
                              association_foreign_key: :spina_conferences_conference_id
      has_and_belongs_to_many :presentations,
                              foreign_key: :spina_conferences_delegate_id,
                              association_foreign_key: :spina_conferences_presentation_id
      has_and_belongs_to_many :dietary_requirements,
                              foreign_key: :spina_conferences_delegate_id,
                              association_foreign_key: :spina_conferences_dietary_requirement_id

      validates_presence_of :first_name, :last_name, :email_address, :conferences
      validates :email_address, email_address: true, unless: (proc do |a|
        a.email_address.blank?
      end)

      scope :sorted, -> { order :last_name, :first_name }

      # Returns first name and last name, used to address delegates.
      def full_name
        "#{first_name} #{last_name}"
      end

      # Returns full name and institution, used to identify delegates.
      def full_name_and_institution
        full_name + ", #{institution.name}"
      end

      # Returns last name and first name, used for sorting delegates.
      def reversed_name
        "#{last_name}, #{first_name}"
      end

      # Returns reversed name and institution, used for sorting delegates.
      def reversed_name_and_institution
        reversed_name + ", #{institution.name}"
      end
    end
  end
end
