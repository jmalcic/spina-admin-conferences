# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class Delegation < ApplicationRecord
        # @!attribute [rw] first_name
        #   @return [String, nil] the first name of the delegate
        # @!attribute [rw] last_name
        #   @return [String, nil] the last name of the delegate

        # @return [ActiveRecord::Relation] all delegations, ordered by last name and first name
        scope :sorted, -> { order :last_name, :first_name }

        # @!attribute [rw] conference
        #   @return [Conference, nil] directly associated conference
        #   @see Conference
        belongs_to :conference, inverse_of: :delegations
        # @!attribute [rw] delegate
        #   @return [Delegate, nil] directly associated Delegate
        #   @see Delegate
        belongs_to :delegate, inverse_of: :delegations
        # @!attribute [rw] affiliations
        #   @return [ActiveRecord::Relation] directly associated affiliations
        #   @note Destroying a conference destroys dependent affiliations.
        #   @see DelegationAffiliation
        has_many :affiliations, class_name: 'Spina::Admin::Conferences::DelegationAffiliation', inverse_of: :delegation, dependent: :destroy
        # @!attribute [rw] authorships
        #   @return [ActiveRecord::Relation] directly associated authorships
        #   @note Destroying a conference destroys dependent authorships.
        #   @see Authorship
        has_many :authorships, inverse_of: :delegation, dependent: :destroy
        # @!attribute [rw] institutions
        #   @return [ActiveRecord::Relation] Institutions associated with {#affiliations}
        #   @see Institution
        #   @see DelegationAffiliation#institution
        has_many :institutions, through: :affiliations

        validates :first_name, :last_name, presence: true

        # @return [String] the first name and last name of the delegate
        def full_name
          return if first_name.blank? || last_name.blank?

          Delegation.human_attribute_name :full_name, first_name: first_name, last_name: last_name
        end

        # @return [String] the full name and institution of the delegate
        def full_name_and_institution
          return if full_name.blank? || institutions.empty?

          Delegation.human_attribute_name :name_and_institution, name: full_name,
                                                                 institution: institutions.collect(&:name).to_sentence
        end

        # @return [String] the last name and first name of the delegate
        def reversed_name
          return if first_name.blank? || last_name.blank?

          Delegation.human_attribute_name :reversed_name, first_name: first_name, last_name: last_name
        end

        # @return [String] the reversed name and institution of the delegate
        def reversed_name_and_institution
          return if reversed_name.blank? || institutions.empty?

          Delegation.human_attribute_name :name_and_institution, name: reversed_name,
                                                                 institution: institutions.collect(&:name).to_sentence
        end
      end
    end
  end
end
