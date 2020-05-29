# frozen_string_literal: true

module Spina
  module Conferences
    class ApplicationRecord < ActiveRecord::Base #:nodoc:
      self.abstract_class = true
    end
  end
end
