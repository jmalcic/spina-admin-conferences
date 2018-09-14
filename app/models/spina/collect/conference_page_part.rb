# frozen_string_literal: true

module Spina
  module Collect
    # This class is a join model for the polymorphic `:conference_page_partable`
    # association and a `:conference_page`. Destroying a `ConferencePagePart`
    # destroys the associated `:conference_page_partable` and
    # `:conference_page`. An instance will also build a `ConferencePage` for
    # itself before it gets created, using the `#name` method of
    # `:conference_page_partable`.
    class ConferencePagePart < ApplicationRecord
      before_validation :set_up_resource, :set_up_conference_page, on: :create

      after_destroy do
        conference_page_partable&.destroy if conference_page_partable
      end

      belongs_to :conference_page, inverse_of: :conference_page_part,
                                   dependent: :destroy
      belongs_to :conference_page_partable, polymorphic: true,
                                            inverse_of: :conference_page_part

      private

      def page_partable_parameter
        conference_page_partable.class.name.demodulize.parameterize
      end

      def resource
        page_partable_parameter.pluralize
      end

      def set_up_resource
        Spina::Resource.find_or_create_by(name: resource) do |resource|
          resource.label = resource.name.titleize
          resource.view_template = page_partable_parameter
          if defined? conference_page_partable.class.parent_page
            resource.parent_page_id =
              conference_page_partable.class.parent_page.id
          end
        end
      end

      def set_up_conference_page
        build_conference_page(
          title: conference_page_partable.name,
          view_template: Spina::Resource.find_by(name: resource).view_template,
          deletable: false,
          resource: Spina::Resource.find_by(name: resource)
        )
        set_ancestry
      end

      def set_ancestry
        conference_page.parent_id =
          if defined? conference_page_partable.parent_page
            conference_page_partable.parent_page.id
          else
            Spina::Resource.find_by(name: resource).parent_page_id
          end
      end
    end
  end
end
