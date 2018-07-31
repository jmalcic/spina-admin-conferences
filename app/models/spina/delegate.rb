module Spina
  # This class represents conference delegates.
  # Delegates may belong to multiple conferences, and multiple delegates belong
  # to each conference. Delegates may have (i.e. present) multiple
  # presentations, and multiple delegates may belong to (i.e. be presenting)
  # a single presentation.
  # Destroying a delegate does not affect associated conferences and
  # presentations.
  # The format of delegate emails is validated.
  class Delegate < ApplicationRecord
    has_and_belongs_to_many :conferences, class_name: 'Spina::Conference', foreign_key: 'spina_delegate_id', association_foreign_key: 'spina_conference_id', required: true
    has_and_belongs_to_many :presentations, class_name: 'Spina::Presentation', foreign_key: 'spina_delegate_id', association_foreign_key: 'spina_presentation_id'

    validates_presence_of :first_name, :last_name, :email_address
    validates :email_address, email_address: true, unless: proc { |a| a.email_address.blank? }

    # Returns first name and last name, used to address delegates.
    def full_name
      "#{first_name} #{last_name}"
    end

    # Returns full name and institution, used to identify delegates.
    def full_name_and_institution
      full_name + ", #{institution}"
    end
  end
end
