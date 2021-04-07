# frozen_string_literal: true

module Spina
  module Parts
    module Admin
      module Conferences
        # Email address parts. The format is validated.
        #
        # = Validators
        # Email address (using {EmailAddressValidator}):: {#content}.
        # @see EmailAddressValidator
        class EmailAddress < Spina::Parts::Base
          attr_json :content, :string

          validates :content, 'spina/admin/conferences/email_address': true, allow_blank: true
        end
      end
    end
  end
end
