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
    name: 'minutes',
    title: 'Minutes',
    partable_type: 'Spina::AttachmentCollection'
  }, {
    name: 'partner_societies',
    title: 'Partner societies',
    partable_type: 'Spina::Structure'
  }, {
    name: 'contact',
    title: 'Contact',
    partable_type: 'Spina::Text'
  }, {
    name: 'conferences',
    title: 'Conferences',
    partable_type: 'Spina::ConferenceList'
  }]

  theme.structures = [{
    name: 'partner_societies',
    structure_parts: [{
      name: 'name',
      title: 'Name',
      partable_type: 'Spina::Line'
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
    description: 'Contains information about a conference',
    page_parts: %w[text]
  }, {
    name: 'conferences',
    title: 'Conferences',
    description: 'List of conferences',
    page_parts: %w[conferences]
  }]

  theme.custom_pages = [{
    name: 'homepage',
    title: 'Homepage',
    deletable: false,
    view_template: 'homepage'
  },
  {
    name: 'conferences',
    title: 'Conferences',
    deletable: false,
    view_template: 'conferences'
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
