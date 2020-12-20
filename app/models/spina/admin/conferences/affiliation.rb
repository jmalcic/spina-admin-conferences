# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class Affiliation < ApplicationRecord
        # @!attribute [rw] account
        #   @return [Account, nil] directly associated account
        #   @see Account
        belongs_to :account, inverse_of: :affiliations
        # @!attribute [rw] institution
        #   @return [Institution, nil] directly associated institution
        #   @see Institution
        belongs_to :institution, inverse_of: :affiliations
      end
    end
  end
end
