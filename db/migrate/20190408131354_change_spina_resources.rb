# frozen_string_literal: true

class ChangeSpinaResources < ActiveRecord::Migration[6.0] #:nodoc:
  def up
    update_conferences
    update_presentations
    destroy_old_resources
  end

  def down
    restore_conferences
    restore_presentations
    destroy_new_resources
  end

  def update_conferences
    resource = Spina::Resource.find_or_create_by name: 'conference_pages', label: 'Conference pages'
    Spina::Conferences::Conference.all.each do |conference|
      conference.conference_page.update! parent: nil, resource: resource
    end
  end

  def update_presentations
    resource = Spina::Resource.find_or_create_by name: 'conference_pages', label: 'Conference pages'
    Spina::Conferences::Presentation.all.each do |presentation|
      presentation.conference_page.update! parent: presentation.conference.conference_page, resource: resource
    end
  end

  def restore_conferences
    conferences_resource = Spina::Resource.find_or_create_by name: 'conferences', label: 'Conferences',
                                                             view_template: 'conference'
    Spina::Conferences::Conference.all.each do |conference|
      conference.conference_page.update! parent: Spina::Page.find_by(view_template: 'conferences'),
                                         resource: conferences_resource
    end
  end

  def restore_presentations
    presentations_resource = Spina::Resource.find_or_create_by name: 'presentations', label: 'Presentations',
                                                               view_template: 'presentation'
    Spina::Conferences::Presentation.all.each do |presentation|
      presentation.conference_page.update! parent: presentation.conference.conference_page,
                                           resource: presentations_resource
    end
  end

  def destroy_old_resources
    Spina::Resource.find_by(name: 'conferences')&.destroy
    Spina::Resource.find_by(name: 'presentations')&.destroy
  end

  def destroy_new_resources
    Spina::Resource.find_by(name: 'conference_pages')&.destroy
  end
end
