# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Admin
    module Conferences
      module Importable
        extend ActiveSupport::Concern

        require 'csv'

        included do
          def import_csv(file)
            CSV.read file.path, encoding: 'UTF-8', headers: true,
                                   header_converters: :symbol,
                                   converters: %i[date_time date]
          end
        end
      end
    end
  end
end
