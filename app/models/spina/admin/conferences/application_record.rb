# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # @abstract Subclass to implement a custom record.
      class ApplicationRecord < ActiveRecord::Base
        extend Mobility

        self.abstract_class = true
      end
    end
  end
end
