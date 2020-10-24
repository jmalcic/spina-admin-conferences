# frozen_string_literal: true

require 'spina/admin/conferences/migration/renaming'

module Spina
  module Admin
    module Conferences
      class Railtie < Rails::Railtie
        include Migration::Renaming

        rename_migration 'create_spina_conferences_dietary_requirement_name_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_dietary_requirement_name_translations'
        rename_migration 'create_spina_conferences_institution_name_and_city_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_institution_name_and_city_translations'
        rename_migration 'create_spina_conferences_presentation_attachment_type_name_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_presentation_attachment_type_name_translations'
        rename_migration 'create_spina_conferences_presentation_type_name_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_presentation_type_name_translations'
        rename_migration 'create_spina_conferences_room_building_and_number_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_room_building_and_number_translations'
        rename_migration 'create_spina_conferences_conference_name_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_conference_name_translations'
        rename_migration 'create_spina_conferences_session_name_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_session_name_translations'
        rename_migration 'create_spina_conferences_event_name_description_and_location_translations_for_mobility_table_backend',
                         to: 'create_spina_conferences_event_name_description_and_location_translations'

        config.after_initialize do
          raise_on_duplicate_migrations!
        end
      end
    end
  end
end
