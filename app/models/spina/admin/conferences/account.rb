# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # User accounts.
      #
      # = Validators
      # Absence:: {#unconfirmed} (on update).
      # Presence:: {#email_address}, {#first_name}, {#last_name}.
      # Email address (using {EmailAddressValidator}):: {#email_address}.
      # @see EmailAddressValidator
      # = Callbacks
      # After create:: schedules deletion of unconfirmed account in 14 days.
      class Account < ApplicationRecord
        # @!attribute [rw] first_name
        #   @return [String, nil] the first name of the account holder
        # @!attribute [rw] last_name
        #   @return [String, nil] the last name of the account holder
        # @!attribute [rw] email_address
        #   @return [String, nil] the email address of the account holder

        # @!attribute [rw] delegate
        #   @return [Delegate] directly associated delegate
        #   @note Destroying a conference nullifies the delegate's reference to it.
        #   @see Delegate
        has_one :delegate, inverse_of: :account, dependent: :nullify
        # @!attribute [rw] affiliations
        #   @return [ActiveRecord::Relation] directly associated affiliations
        #   @note Destroying a conference destroys dependent affiliations.
        #   @see Affiliation
        has_many :affiliations, inverse_of: :account, dependent: :destroy
        # @!attribute [rw] institutions
        #   @return [ActiveRecord::Relation] Institutions associated with {#affiliations}
        #   @see Institution
        #   @see Affiliation#institution
        has_many :institutions, through: :affiliations
        # @!method password=(password)
        #   Sets the password
        #   @param password [String] the password
        # @!method password_confirmation=(password_confirmation)
        #   Sets the password confirmation
        #   @param password_confirmation [String] the password confirmation
        # @!method authenticate(password)
        #   Attempts to authenticate using the password.
        #   @param password [String] the password
        #   @return [false, Account] the account if the password is correct, or false otherwise
        has_secure_password
        # @!method regenerate_password_reset_token
        #   Regenerates the secure password reset token.
        has_secure_token :password_reset_token

        validates :unconfirmed, absence: true, on: :update
        validates :email_address, :first_name, :last_name, presence: true
        validates :email_address, 'spina/admin/conferences/email_address': true, uniqueness: true

        after_create :schedule_deletion

        # Set the account to confirmed state.
        # @return [void]
        def confirm
          update unconfirmed: false
        end

        private

        def schedule_deletion
          DeleteUnconfirmedAccountJob.set(wait: 14.days).perform_later(self)
        end
      end
    end
  end
end
