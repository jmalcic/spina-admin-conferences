# frozen_string_literal: true

module Spina
  module Parts
    module Admin
      module Conferences
        # URL parts. The format is validated.
        #
        # = Validators
        # HTTP(S) URL (using {HttpUrlValidator}):: {#content}.
        # @see HttpUrlValidator
        class Url < Spina::Parts::Base
          attr_json :content, :string

          validates :content, 'spina/admin/conferences/http_url': true, allow_blank: true
        end
      end
    end
  end
end
