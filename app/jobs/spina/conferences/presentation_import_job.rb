# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports presentations from CSV files
    class PresentationImportJob < ImportJob
      include ::Spina::Conferences

      queue_as :default

      def perform(csv)
        Presentation.transaction do
          import(csv) do |row|
            room_use = row[:room_use]
            copy_value :conference, from: row, to: room_use
            current_theme = ::Spina::Theme.find_by_name(::Spina::Account.first.theme)
            presentation = Presentation.new
            parts = Presentation.model_parts(current_theme).map { |part| presentation.part(part) }
            presentation.update! title: row[:title], date: row[:date], start_time: row[:start_time],
                                 abstract: row[:abstract], presenters: find_delegates(row[:presenters]),
                                 room_use: find_room_use(room_use), parts: parts
          end
        end
      end
    end
  end
end
