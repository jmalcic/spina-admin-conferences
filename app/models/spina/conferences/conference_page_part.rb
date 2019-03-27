# frozen_string_literal: true

module Spina
  module Conferences
    # This class is a join model for the polymorphic `:conference_page_partable`.
    class ConferencePagePart < ApplicationRecord
      belongs_to :conference_page_partable, polymorphic: true,
                                            inverse_of: :conference_page_part,
                                            dependent: :destroy
      belongs_to :conference_page, inverse_of: :conference_page_part,
                                   dependent: :destroy
    end
  end
end
