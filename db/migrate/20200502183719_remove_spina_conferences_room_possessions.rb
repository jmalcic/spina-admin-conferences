# frozen_string_literal: true

class RemoveSpinaConferencesRoomPossessions < ActiveRecord::Migration[6.0] #:nodoc:
  def up
    add_reference :spina_conferences_room_uses, :room, foreign_key: { to_table: :spina_conferences_rooms }
    update_room_uses_with_room_id
    remove_reference :spina_conferences_room_uses, :room_possession
    drop_table :spina_conferences_room_possessions
    add_timestamps :spina_conferences_room_uses
  end

  def down
    remove_timestamps :spina_conferences_room_uses
    create_room_possessions_table
    add_reference :spina_conferences_room_uses, :room_possession, foreign_key: { to_table: :spina_conferences_room_possessions }
    insert_room_possessions
    update_room_uses_with_room_possession_id
    remove_reference :spina_conferences_room_uses, :room
  end

  private

  def create_room_possessions_table
    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table 'spina_conferences_room_possessions' do |t|
      t.references :room, foreign_key: { to_table: :spina_conferences_rooms }
      t.references :conference, foreign_key: { to_table: :spina_conferences_conferences }
    end
    # rubocop:enable Rails/CreateTableWithTimestamps
  end

  def update_room_uses_with_room_id
    update <<-SQL.squish
      UPDATE "spina_conferences_room_uses"
        SET "room_id" = "spina_conferences_room_possessions"."room_id"
        FROM "spina_conferences_room_uses" AS "room_uses"
        INNER JOIN "spina_conferences_room_possessions"
        ON "spina_conferences_room_possessions"."id" = "room_uses"."room_possession_id"
    SQL
  end

  def insert_room_possessions
    insert <<-SQL.squish
      INSERT INTO "spina_conferences_room_possessions" ("room_id", "conference_id")
        SELECT DISTINCT "spina_conferences_room_uses"."room_id", "spina_conferences_presentation_types"."conference_id"
        FROM "spina_conferences_room_uses"
        INNER JOIN "spina_conferences_presentation_types"
        ON "spina_conferences_presentation_types"."id" = "spina_conferences_room_uses"."presentation_type_id"
    SQL
  end

  def update_room_uses_with_room_possession_id
    update <<-SQL.squish
      UPDATE "spina_conferences_room_uses"
        SET "room_possession_id" = "spina_conferences_room_possessions"."id"
        FROM "spina_conferences_room_uses" AS "room_uses"
        INNER JOIN "spina_conferences_room_possessions"
        ON "spina_conferences_room_possessions"."room_id" = "room_uses"."room_id"
    SQL
  end
end
