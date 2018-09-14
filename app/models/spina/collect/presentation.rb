# frozen_string_literal: true

module Spina
  module Collect
    # This class represents conference presentations.
    # A `Presentation` belongs to a `:conference` and a `:presentation_type`.
    # A `Presentation` may have multiple `:presenters`, instances of
    # `Delegate`, and a `Delegate` may have multiple `:presentations`.
    # The `:date` is validated to make sure it is during the `:conference`.
    class Presentation < ApplicationRecord
      include ConferencePagePartable

      belongs_to :conference
      belongs_to :presentation_type
      belongs_to :room
      has_and_belongs_to_many :presenters,
                              class_name: 'Spina::Collect::Delegate',
                              foreign_key: :spina_collect_presentation_id,
                              association_foreign_key:
                                  :spina_collect_delegate_id
      has_one :conference_page_part, as: :conference_page_partable,
              dependent: :destroy
      has_one :conference_page, through: :conference_page_part

      validates_presence_of :title, :date, :start_time, :abstract, :presenters
      validates :date, conference_date: true, unless: proc { |a| a.date.blank? }

      scope :sorted, -> { order start_time: :desc }

      # `:name` is used by the `:conference_page_part` to create a
      # `ConferencePage`
      alias_attribute :name, :title

      # `#parent_page` is used by the `:conference_page_part` to create a
      # `Resource`
      def parent_page
        conference.conference_page_part.conference_page
      end

      # `#view_template` is used by the `:conference_page_part` to create a
      # `Resource`
      def self.view_template
        name.demodulize.parameterize.pluralize
      end

      def start_datetime
        return unless date && start_time
        date + start_time.hour.hours + start_time.min.minutes
      end
    end
  end
end
