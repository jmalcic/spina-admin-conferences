# frozen_string_literal: true

class SetNameForSpinaConferencesConferences < ActiveRecord::Migration[6.0] # :nodoc:
  def up
    insert <<-SQL.squish
      INSERT INTO "spina_conferences_conference_translations" (
        "locale", "spina_conferences_conference_id", "name", "created_at", "updated_at"
      )
        SELECT
          '#{I18n.default_locale}' "locale",
          "spina_conferences_conferences"."id" AS "spina_conferences_conference_id",
          date_part('year', lower("spina_conferences_conferences"."dates")) AS "name",
          "spina_conferences_conferences"."created_at",
          "spina_conferences_conferences"."updated_at"
        FROM "spina_conferences_conferences"
    SQL
  end

  def down
    update <<-SQL.squish
      WITH conference_to_instutition_map AS (
        SELECT
          "spina_conferences_conferences"."id" AS "conference_id",
          MAX("spina_conferences_rooms"."institution_id") AS "institution_id"
        FROM
          "spina_conferences_conferences"
        LEFT JOIN "spina_conferences_presentation_types" ON
          "spina_conferences_conferences"."id" = "spina_conferences_presentation_types"."conference_id"
        LEFT JOIN "spina_conferences_room_uses" ON
          "spina_conferences_presentation_types"."id" = "spina_conferences_room_uses"."presentation_type_id"
        LEFT JOIN "spina_conferences_room_possessions" ON
          "spina_conferences_room_uses"."room_possession_id" = "spina_conferences_room_possessions"."id"
        LEFT JOIN "spina_conferences_rooms" ON
          "spina_conferences_room_possessions"."room_id" = "spina_conferences_rooms"."id"
        GROUP BY
          "spina_conferences_conferences"."id"
      )
      UPDATE "spina_conferences_conferences"
        SET "institution_id" = "conference_to_instutition_map"."institution_id"
      FROM
        "spina_conferences_conferences" AS "base_table"
      LEFT JOIN conference_to_instutition_map ON
        "base_table"."id" = "conference_to_instutition_map"."conference_id"
    SQL
  end
end
