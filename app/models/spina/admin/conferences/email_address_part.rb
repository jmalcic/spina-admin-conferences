# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Email address parts. The format is validated.
      #
      # = Validators
      # Email address (using {EmailAddressValidator}):: {#content}.
      # @see EmailAddressValidator
      class EmailAddressPart < ApplicationRecord
        has_many :page_parts, as: :page_partable
        has_many :parts, as: :partable
        has_many :layout_parts, as: :layout_partable
        has_many :structure_parts, as: :structure_partable

        validates :content, 'spina/admin/conferences/email_address': true, allow_blank: true
      end
    end
  end
end
