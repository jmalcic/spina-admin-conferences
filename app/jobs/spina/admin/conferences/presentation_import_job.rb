# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Job for importing {Presentation} objects
      # @see Presentation
      class PresentationImportJob < ImportJob
        queue_as :default

        # Performs the job.
        # @param csv [String] the UTF-8-encoded string to parse as a CSV
        def perform(csv)
          Presentation.transaction do
            import(csv) do |row|
              row[:session][:room][:institution] = Institution.i18n.find_by(row[:session][:room][:institution])
              row[:session][:room] = Room.i18n.find_by(row[:session][:room])
              row[:session][:presentation_type] = PresentationType.i18n.find_by(row[:session][:presentation_type])
              session = Session.find_by(row[:session])
              presenters = row[:presenters].collect do |params|
                params[:institution] = Institution.i18n.find_by(params[:institution])
                Delegate.includes(:institution).find_by(params)
              end
              Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                   abstract: row[:abstract], session: session, presenters: presenters
            end
          end
        end
      end
    end
  end
end
