# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # Appends view path corresponding to root of template views
    module LoadPathExtensions
      extend ActiveSupport::Concern

      included do
        append_view_path File.expand_path('../../views/conference', __dir__)
      end
    end
  end
end
