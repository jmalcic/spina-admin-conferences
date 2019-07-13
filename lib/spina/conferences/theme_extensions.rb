# frozen_string_literal: true

module Spina
  module Conferences
    # Adds method to initializer setting instance variable
    module ThemeExtensions
      extend ActiveSupport::Concern

      included do
        attr_accessor :models

        redefine_method(:initialize) { method(:initialize) << proc { @models = [] } }
      end
    end
  end
end
