# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Job for importing {Delegate} objects.
      # @see Delegate
      class DelegateImportJob < ImportJob
        queue_as :default

        # Performs the job.
        # @param csv [String] the UTF-8-encoded string to parse as a CSV
        #   == Columns
        #   The CSV should has the following columns. Make sure to include the column names in the header row.
        #   +first_name+:: The first name of the delegate.
        #   +last_name+:: The last name of the delegate.
        #   +email_address+:: The email address of the delegate.
        #   +institution_id+:: The id of the current institution of the delegate.
        #   +dietary_requirement_ids+:: The ids of the dietary requirements of the delegate.
        #
        # @return [void]
        def perform(csv)
          Delegate.transaction do
            import(csv) { |row| Delegate.create! delegate_params(row.to_h) }
          end
        end

        private

        def delegate_params(params)
          params = ActionController::Parameters.new(params)
          params.permit :first_name, :last_name, :email_address, :institution_id, conference_ids: [], dietary_requirement_ids: []
        end
      end
    end
  end
end
