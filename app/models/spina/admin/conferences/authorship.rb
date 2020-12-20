# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class Authorship < ApplicationRecord
        # @!attribute [rw] presentation
        #   @return [Presentation, nil] directly associated presentation
        #   @see Presentation
        belongs_to :presentation
        # @!attribute [rw] delegation
        #   @return [Delegation, nil] directly associated delegation
        #   @see Delegation
        belongs_to :delegation
      end
    end
  end
end
