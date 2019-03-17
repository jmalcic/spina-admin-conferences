module Spina
  module Conferences
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
