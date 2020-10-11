# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Delegate records.
      #
      # = Validators
      # Presence:: {#first_name}, {#last_name}.
      # Email address (using {EmailAddressValidator}):: {#email_address}.
      # HTTP(S) URL (using {HttpUrlValidator}):: {#url}.
      # @see EmailAddressValidator
      # @see HttpUrlValidator
      class Delegate < ApplicationRecord
        # @!attribute [rw] first_name
        #   @return [String, nil] the first name of the delegate
        # @!attribute [rw] last_name
        #   @return [String, nil] the last name of the delegate
        # @!attribute [rw] email_address
        #   @return [String, nil] the email address of the delegate
        # @!attribute [rw] url
        #   @return [String, nil] the website belonging to the delegate

        # @return [ActiveRecord::Relation] all delegates, ordered by last name and first name
        scope :sorted, -> { order :last_name, :first_name }

        # @!attribute [rw] institution
        #   @return [Institution, nil] directly associated institution
        #   @see Institution
        belongs_to :institution, inverse_of: :delegates, touch: true
        # @!attribute [rw] conferences
        #   @return [ActiveRecord::Relation] directly associated conferences
        #   @see Conference
        has_and_belongs_to_many :conferences, -> { includes(:translations) }, foreign_key: :spina_conferences_delegate_id, # rubocop:disable Rails/HasAndBelongsToMany
                                                                              association_foreign_key: :spina_conferences_conference_id
        # @!attribute [rw] presentations
        #   @return [ActiveRecord::Relation] directly associated presentations
        #   @see Presentation
        has_and_belongs_to_many :presentations, -> { includes(:translations) }, foreign_key: :spina_conferences_delegate_id, # rubocop:disable Rails/HasAndBelongsToMany
                                                                                association_foreign_key: :spina_conferences_presentation_id
        # @!attribute [rw] dietary_requirements
        #   @return [ActiveRecord::Relation] directly associated dietary requirements
        #   @see DietaryRequirement
        has_and_belongs_to_many :dietary_requirements, -> { includes(:translations) }, foreign_key: :spina_conferences_delegate_id, # rubocop:disable Rails/HasAndBelongsToMany
                                                                                       association_foreign_key: :spina_conferences_dietary_requirement_id

        validates :first_name, :last_name, presence: true
        validates :email_address, 'spina/admin/conferences/email_address': true
        validates :url, 'spina/admin/conferences/http_url': true

        # Imports a conference from CSV.
        # @param file [String] the CSV file to be read
        # @return [void]
        # @see DelegateImportJob
        def self.import(file)
          DelegateImportJob.perform_later Pathname.new(file).read
        end

        # @return [String] the first name and last name of the delegate
        def full_name
          return if first_name.blank? || last_name.blank?

          Delegate.human_attribute_name :full_name, first_name: first_name, last_name: last_name
        end

        # @return [String] the full name and institution of the delegate
        def full_name_and_institution
          return if full_name.blank? || institution.blank?

          Delegate.human_attribute_name :name_and_institution, name: full_name, institution: institution.name
        end

        # @return [String] the last name and first name of the delegate
        def reversed_name
          return if first_name.blank? || last_name.blank?

          Delegate.human_attribute_name :reversed_name, first_name: first_name, last_name: last_name
        end

        # @return [String] the reversed name and institution of the delegate
        def reversed_name_and_institution
          return if reversed_name.blank? || institution.blank?

          Delegate.human_attribute_name :name_and_institution, name: reversed_name, institution: institution.name
        end
      end
    end
  end
end
