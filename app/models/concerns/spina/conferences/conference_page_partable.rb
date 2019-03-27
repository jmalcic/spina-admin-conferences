# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Conferences
    # This module adds a `has_one` relation to a `:conference_page_part` and a callback to build a `ConferencePagePart`
    # before the creation of an instance.
    module ConferencePagePartable
      extend ActiveSupport::Concern

      included do
        attr_reader :conference_page

        define_model_callbacks :initializer

        delegate :materialized_path, to: :'conference_page_part.conference_page'

        after_initializer :set_up_resource
        before_validation :set_up_conference_page, on: :create
        after_destroy { conference_page_part&.destroy }

        has_one :conference_page_part, as: :conference_page_partable, inverse_of: :conference_page_partable
        has_one :conference_page, through: :conference_page_part

        private

        def set_up_resource
          resource_name = self.class.name.demodulize.parameterize
          @resource = Spina::Resource.find_or_create_by(name: resource_name.pluralize) do |resource|
            resource.label = resource_name.pluralize.titleize
            resource.view_template = resource_name
          end
        end

        def set_up_conference_page
          template = @resource&.view_template || set_up_resource&.view_template
          self.conference_page = ConferencePage.create(title: name, view_template: template, deletable: false,
                                                       resource: @resource)
        end
      end
    end
  end
end
