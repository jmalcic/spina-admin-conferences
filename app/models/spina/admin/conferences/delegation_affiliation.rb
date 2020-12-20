# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class DelegationAffiliation < ApplicationRecord
        # @!attribute [rw] delegation
        #   @return [Delegation, nil] directly associated delegation
        #   @see Delegation
        belongs_to :delegation
        # @!attribute [rw] institution
        #   @return [Institution, nil] directly associated institution
        #   @see Institution
        belongs_to :institution
      end
    end
  end
end
