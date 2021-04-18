# frozen_string_literal: true

class MoveTextsToActionTextRichTexts < ActiveRecord::Migration[6.1]
  def up
    create_table :mobility_text_translations do |t|
      t.string :record
    end
    create_table :mobility_string_translations do |t|
      t.string :record
    end

    Spina.config.locales.each do |locale|
      I18n.with_locale(locale) do
        Spina::Admin::Conferences::PresentationTranslation.where(locale: locale).in_batches.each_record do |presentation_translation|
          presentation_translation.presentation.update(abstract: presentation_translation.abstract)
        end
        Spina::Admin::Conferences::EventTranslation.where(locale: locale).in_batches.each_record do |event_translation|
          event_translation.event.update(description: event_translation.description)
        end
      end
    end

    remove_column :spina_conferences_presentation_translations, :abstract
    remove_column :spina_conferences_event_translations, :description
  end

  def down
    add_column :spina_conferences_presentation_translations, :abstract, :text
    add_column :spina_conferences_event_translations, :description, :text

    Spina.config.locales.each do |locale|
      I18n.with_locale(locale) do
        Spina::Admin::Conferences::PresentationTranslation.where(locale: locale).in_batches.each_record do |presentation_translation|
          rich_text = ActionText::RichText.find_by(record: presentation_translation.presentation, name: 'abstract')
          if rich_text
            presentation_translation.update(abstract: rich_text.read_attribute_before_type_cast('body'))
            rich_text.destroy
          end
        end
        Spina::Admin::Conferences::EventTranslation.where(locale: locale).in_batches.each_record do |event_translation|
          rich_text = ActionText::RichText.find_by(record: event_translation.event, name: 'description')
          if rich_text
            event_translation.update(description: rich_text.read_attribute_before_type_cast('body'))
            rich_text.destroy
          end
        end
      end
    end

    change_column_null :spina_conferences_presentation_translations, :abstract, false
    change_column_null :spina_conferences_event_translations, :description, false
    drop_table :mobility_text_translations
    drop_table :mobility_string_translations
  end
end

module Spina
  module Admin
    module Conferences
      class PresentationTranslation < ApplicationRecord
        belongs_to :presentation, foreign_key: 'spina_conferences_presentation_id'
      end

      class EventTranslation < ApplicationRecord
        belongs_to :event, foreign_key: 'spina_conferences_event_id'
      end

      class Presentation < ApplicationRecord
        has_many :presentation_translations, foreign_key: 'spina_conferences_presentation_id'

        translates :abstract, backend: :action_text
      end

      class Event < ApplicationRecord
        has_many :event_translations, foreign_key: 'spina_conferences_event_id'

        translates :description, backend: :action_text
      end
    end
  end
end
