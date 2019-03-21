# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # This module adds a `has_one` relation to a `:conference_page_part` and
    # a callback to build a `ConferencePagePart` before the creation of an
    # instance.
    module ConferencePagePartable
      extend ActiveSupport::Concern

      included do
        before_validation :set_up_resource, :set_up_conference_page, on: :create
        after_destroy { conference_page_part&.destroy }

        has_one :conference_page_part, as: :conference_page_partable
        has_one :conference_page, through: :conference_page_part

        private

        def page_partable_parameter
          self.class.name.demodulize.parameterize
        end

        def resource
          page_partable_parameter.pluralize
        end

        def set_up_resource
          Spina::Resource.find_or_create_by(name: resource) do |resource|
            resource.label = resource.name.titleize
            resource.view_template = page_partable_parameter
            resource.parent_page_id = self.class.parent_page.id if defined? self.class.parent_page
          end
        end

        def set_up_conference_page
          @conference_page = Spina::Conferences::ConferencePage.new(
            title: name,
            view_template:
              Spina::Resource.find_by(name: resource).view_template,
            deletable: false,
            resource: Spina::Resource.find_by(name: resource),
            parent_id: set_ancestry
          )
          set_ancestry
          self.conference_page = @conference_page
        end

        def set_ancestry
          if defined? parent_page
            parent_page&.id
          else
            Spina::Resource.find_by(name: resource).parent_page_id
          end
        end
      end
    end
  end
end
