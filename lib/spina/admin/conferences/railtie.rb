# frozen_string_literal: true

require 'spina/admin/conferences/migration/renaming'

module Spina
  module Admin
    module Conferences
      class Railtie < Rails::Railtie
        include Migration::Renaming

        config.after_initialize do
          raise_on_duplicate_migrations!
        end
      end
    end
  end
end
