# frozen_string_literal: true

module Spina
  module Conferences
    module ThemeExtensions
      # Adds method to initializer setting instance variable
      extend ActiveSupport::Concern

      included do
        attr_accessor :models

        redefine_method(:initialize) { method(:initialize) << proc { @models = [] } }
      end
    end
  end
end
