# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      class ApplicationRecord < ActiveRecord::Base #:nodoc:
        extend Mobility

        self.abstract_class = true
      end
    end
  end
end
