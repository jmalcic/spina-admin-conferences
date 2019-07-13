# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # This module adds a `has_one` relation to a `:conference_page_part` and a callback to build a `ConferencePagePart`
    # before the creation of an instance.
    module ConferencePagePartable
      extend ActiveSupport::Concern

      included do
        delegate :materialized_path, to: :'conference_page_part.conference_page'

        has_one :conference_page_part, as: :conference_page_partable, inverse_of: :conference_page_partable,
                                       dependent: false
        has_one :conference_page, through: :conference_page_part

        private

        def set_up_conference_page
          resource = Spina::Resource.find_or_create_by name: 'conference_pages', label: 'Conference pages'
          template = self.class.name.demodulize.parameterize
          self.conference_page = ConferencePage.create title: name, view_template: template, deletable: false,
                                                       resource: resource
        end
      end
    end
  end
end
