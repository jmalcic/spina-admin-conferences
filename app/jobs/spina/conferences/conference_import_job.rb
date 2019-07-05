# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports conferences from CSV files
    class ConferenceImportJob < ImportJob
      include ::Spina::Conferences

      queue_as :default

      def perform(csv)
        Conference.transaction do
          import(csv) do |row|
            rooms = row[:rooms]
            copy_value :institution, from: row, to: rooms
            current_theme = ::Spina::Theme.find_by_name(::Spina::Account.first.theme)
            conference = Conference.new
            parts = Conference.model_parts(current_theme).map { |part| conference.part(part) }
            conference.update! institution: find_institution(row[:institution]), start_date: row[:start_date],
                               finish_date: row[:finish_date], rooms: find_rooms(rooms), parts: parts
          end
        end
      end
    end
  end
end
