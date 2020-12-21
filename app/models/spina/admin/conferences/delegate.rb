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
        # @!attribute [rw] email_address
        #   @return [String, nil] the email address of the delegate
        # @!attribute [rw] url
        #   @return [String, nil] the website belonging to the delegate

        # @!attribute [rw] account
        #   @return [Account, nil] directly associated delegate
        #   @see Account
        belongs_to :account, inverse_of: :delegate, optional: true
        # @!attribute [rw] delegations
        #   @return [ActiveRecord::Relation] directly associated delegations
        #   @note Destroying a delegate destroys dependent delegations.
        #   @see Delegation
        has_many :delegations, inverse_of: :delegate, dependent: :destroy
        # @!attribute [rw] authorships
        #   @return [ActiveRecord::Relation] Authorships associated with #{delegations}
        #   @see Authorship
        #   @see Delegation#authorship
        has_many :authorships, through: :delegations
        # @!attribute [rw] conferences
        #   @return [ActiveRecord::Relation] Conferences associated with #{delegations}
        #   @see Conference
        #   @see Delegation#conference
        has_many :conferences, through: :delegations
        # @!attribute [rw] authorships
        #   @return [ActiveRecord::Relation] Presentations associated with #{authorships}
        #   @see Presentation
        #   @see Authorship#presentation
        has_many :presentations, through: :authorships
        # @!attribute [rw] dietary_requirements
        #   @return [ActiveRecord::Relation] directly associated dietary requirements
        #   @see DietaryRequirement
        has_and_belongs_to_many :dietary_requirements, -> { includes(:translations) }, foreign_key: :spina_conferences_delegate_id, # rubocop:disable Rails/HasAndBelongsToMany
                                                       association_foreign_key: :spina_conferences_dietary_requirement_id
        accepts_nested_attributes_for :delegations

        validates :email_address, 'spina/admin/conferences/email_address': true
        validates :url, 'spina/admin/conferences/http_url': true

        # Imports a conference from CSV.
        # @param file [String] the CSV file to be read
        # @return [void]
        # @see DelegateImportJob
        def self.import(file)
          DelegateImportJob.perform_later Pathname.new(file).read
        end
      end
    end
  end
end
