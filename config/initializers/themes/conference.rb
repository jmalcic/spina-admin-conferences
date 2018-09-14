# frozen_string_literal: true

::Spina::Theme.register do |theme|
  theme.name = 'conference'
  theme.title = 'Conference theme'

  theme.page_parts = [{
    name: 'alert',
    title: 'Alert',
    partable_type: 'Spina::Line'
  }, {
    name: 'text',
    title: 'Text',
    partable_type: 'Spina::Text'
  }, {
    name: 'gallery',
    title: 'Gallery',
    partable_type: 'Spina::ImageCollection'
  }, {
    name: 'constitution',
    title: 'Constitution',
    partable_type: 'Spina::Attachment'
  }, {
    name: 'partner_societies',
    title: 'Partner societies',
    partable_type: 'Spina::Structure'
  }, {
    name: 'minutes',
    title: 'Minutes',
    partable_type: 'Spina::Structure'
  }, {
    name: 'contact',
    title: 'Contact',
    partable_type: 'Spina::Text'
  }]

  theme.structures = [{
    name: 'partner_societies',
    structure_parts: [{
      name: 'name',
      title: 'Name',
      partable_type: 'Spina::Line'
    }, {
      name: 'logo',
      title: 'Logo',
      partable_type: 'Spina::Image'
    }, {
      name: 'description',
      title: 'Description',
      partable_type: 'Spina::Text'
    }, {
      name: 'website',
      title: 'Website',
      partable_type: 'Spina::Url'
    }, {
      name: 'email_address',
      title: 'Email address',
      partable_type: 'Spina::EmailAddress'
    }]
  }, {
    name: 'minutes',
    structure_parts: [{
      name: 'date',
      title: 'Date',
      partable_type: 'Spina::Date'
    }, {
      name: 'attachment',
      title: 'Attachment',
      partable_type: 'Spina::Attachment'
    }]
  }]

  theme.view_templates = [{
    name: 'homepage',
    title: 'Homepage',
    page_parts: %w[text alert gallery]
  }, {
    name: 'information',
    title: 'Information',
    description: 'Contains general information',
    page_parts: %w[text]
  }, {
    name: 'about',
    title: 'About',
    description: 'Contains information about the society',
    page_parts: %w[constitution minutes partner_societies contact]
  }, {
    name: 'conference',
    title: 'Conference',
    description: 'Contains information and content for a conference',
    page_parts: %w[text]
  }, {
    name: 'presentation',
    title: 'Presentation',
    description: 'Contains content for a presentation',
    page_parts: %w[]
  }, {
    name: 'conferences',
    title: 'Conferences',
    description: 'List of conferences',
    page_parts: %w[]
  }]

  theme.custom_pages = [{
    name: 'homepage',
    title: 'Homepage',
    deletable: false,
    view_template: 'homepage'
  }, {
    name: 'conferences',
    title: 'Conferences',
    deletable: false,
    view_template: 'conferences'
  }, {
    name: 'about',
    title: 'About',
    deletable: false,
    view_template: 'about'
  }]

  theme.navigations = [{
    name: 'main',
    label: 'Main navigation',
    auto_add_pages: true
  }, {
    name: 'footer',
    label: 'Footer'
  }]

  theme.plugins = ['collect']
end
