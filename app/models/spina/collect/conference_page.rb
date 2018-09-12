# frozen_string_literal: true

module Spina
  module Collect
    # This class inherits from `Spina::Page` and differs in having a
    # `:conference_page_part`. If a `ConferencePage` is destroyed, the
    # `:conference_page_part` is also destroyed.
    class ConferencePage < Spina::Page
      after_create do
        navigations << Spina::Navigation.where(auto_add_pages: true)
      end

      has_one :conference_page_part, dependent: :destroy
      has_one :conference, through: :conference_page_part,
                           source: :conference_page_partable,
                           source_type: 'Spina::Collect::Conference'
      has_one :presentation, through: :conference_page_part,
                             source: :conference_page_partable,
                             source_type: 'Spina::Collect::Presentation'
    end
  end
end
