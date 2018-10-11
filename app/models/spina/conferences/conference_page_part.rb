# frozen_string_literal: true

module Spina
  module Conferences
    # This class is a join model for the polymorphic `:conference_page_partable`
    # association and a `:conference_page`. Destroying a `ConferencePagePart`
    # destroys the associated `:conference_page_partable` and
    # `:conference_page`. An instance will also build a `ConferencePage` for
    # itself before it gets created, using the `#name` method of
    # `:conference_page_partable`.
    class ConferencePagePart < ApplicationRecord
      belongs_to :conference_page_partable, polymorphic: true,
                                            inverse_of: :conference_page_part,
                                            dependent: :destroy
      belongs_to :conference_page, inverse_of: :conference_page_part,
                                   dependent: :destroy
    end
  end
end
