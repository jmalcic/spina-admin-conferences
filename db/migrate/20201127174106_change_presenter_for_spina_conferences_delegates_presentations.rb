# frozen_string_literal: true

class ChangePresenterForSpinaConferencesDelegatesPresentations < ActiveRecord::Migration[6.0]
  def change
    rename_table :spina_conferences_delegates_presentations, :spina_conferences_authorships
    rename_column :spina_conferences_authorships, :spina_conferences_presentation_id, :presentation_id
    rename_column :spina_conferences_authorships, :spina_conferences_delegate_id, :delegation_id
    change_table :spina_conferences_authorships do |t|
      t.column :id, :primary_key
    end
    reversible do |dir|
      Spina::Admin::Conferences::Authorship.reset_column_information
      dir.up do
        Spina::Admin::Conferences::Authorship.in_batches.each_record do |authorship|
          presentation = Spina::Admin::Conferences::Presentation.find(authorship.presentation_id)
          session = Spina::Admin::Conferences::Session.find(presentation.session_id)
          presentation_type = Spina::Admin::Conferences::PresentationType.find(session.presentation_type_id)
          authorship.delegation_id = Spina::Admin::Conferences::Delegation.find_by(delegate_id: authorship.delegation_id,
                                                                                   conference_id: presentation_type.conference_id).id
          authorship.save validate: false
        end
      end
      dir.down do
        Spina::Admin::Conferences::Authorship.in_batches.each_record do |authorship|
          authorship.delegation_id = Spina::Admin::Conferences::Delegation.find(authorship.delegation_id).delegate_id
          authorship.save validate: false
        end
      end
    end
  end
end
