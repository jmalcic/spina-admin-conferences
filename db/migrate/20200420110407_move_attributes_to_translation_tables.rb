# frozen_string_literal: true

class MoveAttributesToTranslationTables < ActiveRecord::Migration[6.0] # :nodoc:
  def up
    insert_translations('spina_conferences_dietary_requirements', 'name')
    insert_translations('spina_conferences_institutions', 'name', 'city')
    insert_translations('spina_conferences_presentations', 'title', 'abstract')
    insert_translations('spina_conferences_presentation_attachment_types', 'name')
    insert_translations('spina_conferences_presentation_types', 'name')
    insert_translations('spina_conferences_rooms', 'building', 'number')
  end

  def down
    update_record_with_attributes('spina_conferences_dietary_requirements', 'name')
    update_record_with_attributes('spina_conferences_institutions', 'name', 'city')
    update_record_with_attributes('spina_conferences_presentations', 'title', 'abstract')
    update_record_with_attributes('spina_conferences_presentation_attachment_types', 'name')
    update_record_with_attributes('spina_conferences_presentation_types', 'name')
    update_record_with_attributes('spina_conferences_rooms', 'building', 'number')
  end

  private

  def update_record_with_attributes(base_table_name, *attributes)
    update <<-SQL.squish
      UPDATE "#{base_table_name}"
        SET #{set_attribute_strings(base_table_name, attributes).join(',')}
        FROM "#{base_table_name}" as "base_table"
        INNER JOIN "#{base_table_name.singularize}_translations"
        ON "base_table"."id" = "#{base_table_name.singularize}_translations"."#{base_table_name.singularize}_id"
    SQL
  end

  def insert_translations(base_table_name, *attributes)
    insert <<-SQL.squish
      INSERT INTO "#{base_table_name.singularize}_translations" (
        "locale", "#{base_table_name.singularize}_id", #{attribute_strings(attributes).join(',')}
      )
        SELECT
          '#{I18n.default_locale}' "locale",
          "#{base_table_name}"."id" AS "#{base_table_name.singularize}_id",
          #{table_attribute_strings(base_table_name, attributes).join(',')}
        FROM "#{base_table_name}"
    SQL
  end

  def attribute_strings(attributes)
    attributes.collect { |attribute| "\"#{attribute}\"" }
  end

  def table_attribute_strings(base_table_name, attributes)
    attributes.collect { |attribute| "\"#{base_table_name}\".\"#{attribute}\"" }
  end

  def set_attribute_strings(base_table_name, attributes)
    attributes.collect { |attribute| "\"#{attribute}\" = \"#{base_table_name.singularize}_translations\".\"#{attribute}\"" }
  end
end
