# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Collect
    # This module adds a `has_one` relation to a `:conference_page_part` and
    # a callback to build a `ConferencePagePart` before the creation of an
    # instance.
    module ConferencePagePartable
      extend ActiveSupport::Concern

      included do
        before_validation(on: :create) { build_conference_page_part }

        has_one :conference_page_part, as: :conference_page_partable,
                                       dependent: :destroy
      end
    end
  end
end
