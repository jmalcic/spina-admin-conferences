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
        #   == Columns
        #   The CSV should has the following columns. Make sure to include the column names in the header row.
        #   +session_id+:: The id of the associated session.
        #   +start_datetime+:: The start time of the presentation, in ISO 8601 format.
        #   +title+:: The title of the presentation for the default locale.
        #   +abstract+:: The presentation's abstract.
        #   +presenter_ids+:: The ids of the presenters.
        #
        # @return [void]
        def perform(csv)
          Presentation.transaction do
            import(csv) { |row| Presentation.create! presentation_params(row.to_h) }
          end
        end

        private

        def presentation_params(params)
          params = ActionController::Parameters.new(params)
          params.permit :title, :start_datetime, :abstract, :session_id, presenter_ids: []
        end
      end
    end
  end
end
