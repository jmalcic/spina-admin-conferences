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
        #   +presentation_type+:: The associated presentation type, formatted as JSON.
        #   +room+:: The associated room, formatted as JSON.
        #   +date+:: The date of the presentation, in ISO 8601 format.
        #   +start_time+:: The start time of the presentation, in HH:MM format.
        #   +title+:: The title of the presentation for the default locale.
        #   +abstract+:: The presentation's abstract.
        #   +presenters+:: The presenters, formatted as JSON.
        #
        #   == JSON columns
        #
        #   === +presentation_type+
        #   A JSON object containing the presentation type's attributes (attributes will be looked up assuming the default locale).
        #   See the example below.
        #   Note in particular the format for entering the dates, where the first date is the start date and the second is the end date
        #   (both in ISO 8601).
        #     {
        #       "name": "Oral",
        #       "conference": {
        #         "dates": "[2017-04-07,2017-04-09]",
        #         "name": "University of Atlantis 2017"
        #       }
        #     }
        #
        #   === +room+
        #   A JSON object containing the room's attributes (attributes will be looked up assuming the default locale).
        #   See the example below.
        #     {
        #       "building": "Lecture block",
        #       "number": "2",
        #       "institution": {
        #         "name": "University of Atlantis",
        #         "city": "Atlantis"
        #       }
        #     }
        #
        #   === +presenters+
        #   A JSON array of objects containing the attributes of each presenter (attributes will be looked up assuming the default locale).
        #   See the example below.
        #     [
        #       {
        #         "first_name": "Joe",
        #         "last_name": "Bloggs",
        #         "institution": {
        #           "name": "University of Atlantis",
        #           "city": "Atlantis"
        #         }
        #       },
        #       {
        #         "first_name": "John",
        #         "last_name": "Doe",
        #         "institution": {
        #           "name": "University of Shangri-La",
        #           "city": "Shangri-La"
        #         }
        #       }
        #     ]
        #
        # @return [void]
        def perform(csv)
          Presentation.transaction do
            import(csv) do |row|
              row[:room][:institution] = Institution.i18n.find_by(row[:room][:institution])
              row[:room] = Room.i18n.find_by(row[:room])
              row[:presentation_type][:conference] = Conference.i18n.find_by(row[:presentation_type][:conference])
              row[:presentation_type] = PresentationType.i18n.find_by(row[:presentation_type])
              row[:presenters] = row[:presenters].collect do |params|
                params[:institution] = Institution.i18n.find_by(params[:institution])
                Delegate.includes(:institution).find_by(params)
              end
              Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time], abstract: row[:abstract],
                                   session: Session.find_by(room: row[:room], presentation_type: row[:presentation_type]),
                                   presenters: row[:presenters]
            end
          end
        end
      end
    end
  end
end
