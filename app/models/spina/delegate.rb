module Spina
  # This class represents conference delegates.
  # Delegates may belong to multiple conferences, and multiple delegates belong
  # to each conference. Delegates may have (i.e. present) multiple
  # presentations, and multiple delegates may belong to (i.e. be presenting)
  # a single presentation. Delegates have many dietary requirements.
  # Destroying a delegate does not affect associated conferences and
  # presentations.
  # The format of delegate emails is validated.
  class Delegate < ApplicationRecord
    has_and_belongs_to_many :conferences,
                            class_name: 'Spina::Conference',
                            foreign_key: 'spina_delegate_id',
                            association_foreign_key: 'spina_conference_id',
                            required: true
    has_and_belongs_to_many :presentations,
                            class_name: 'Spina::Presentation',
                            foreign_key: 'spina_delegate_id',
                            association_foreign_key: 'spina_presentation_id'
    has_and_belongs_to_many :dietary_requirements,
                            class_name: 'Spina::DietaryRequirement',
                            foreign_key: 'spina_delegate_id',
                            association_foreign_key: 'spina_dietary_requirement_id'

    validates_presence_of :first_name, :last_name, :email_address
    validates :email_address, email_address: true, unless: (proc do |a|
      a.email_address.blank?
    end)

    scope :sorted, -> { order(:last_name, :first_name) }

    # Returns first name and last name, used to address delegates.
    def full_name
      "#{first_name} #{last_name}"
    end

    # Returns full name and institution, used to identify delegates.
    def full_name_and_institution
      full_name + ", #{institution}"
    end

    # Returns last name and first name, used for sorting delegates.
    def reversed_name
      "#{last_name}, #{first_name}"
    end

    # Returns reversed name and institution, used for sorting delegates.
    def reversed_name_and_institution
      reversed_name + ", #{institution}"
    end
  end
end
