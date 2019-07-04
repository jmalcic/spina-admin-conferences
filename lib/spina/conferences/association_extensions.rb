# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    module AssociationExtensions
      extend ActiveSupport::Concern

      included do
        has_one :part, as: :partable, class_name: 'Spina::Conferences::Part'
      end
    end
  end
end
