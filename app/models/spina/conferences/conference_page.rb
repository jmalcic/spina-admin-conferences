# frozen_string_literal: true

module Spina
  module Conferences
    # This class inherits from `Spina::Page` and differs in having a
    # `:conference_page_part`.
    class ConferencePage < Page
      after_create do
        unless resource
          navigations << Spina::Navigation.where(auto_add_pages: true)
        end
      end

      has_one :conference_page_part, dependent: :destroy
      has_one :conference, through: :conference_page_part,
                           source: :conference_page_partable,
                           source_type: 'Spina::Conferences::Conference'
      has_one :presentation, through: :conference_page_part,
                             source: :conference_page_partable,
                             source_type: 'Spina::Conferences::Presentation'
    end
  end
end
