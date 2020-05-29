# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports rooms from CSV files
    class DelegateImportJob < ImportJob
      queue_as :default

      def perform(csv)
        Delegate.transaction do
          import(csv) do |row|
            delegate = find_or_create_delegate(row)
            unless delegate.new_record?
              set_params delegate, row
              delegate.save
            end
          end
        end
      end

      def find_or_create_delegate(row)
        Delegate.find_or_create_by! email_address: row[:email_address] do |new_delegate|
          new_delegate.first_name = row[:first_name]
          new_delegate.last_name = row[:last_name]
          set_params new_delegate, row
        end
      end

      def set_params(delegate, row)
        delegate.institution = find_institution(row[:institution])
        delegate.dietary_requirements = find_dietary_requirements(row[:dietary_requirements])
        delegate.conferences.concat find_conferences(row[:conferences])
      end
    end
  end
end
