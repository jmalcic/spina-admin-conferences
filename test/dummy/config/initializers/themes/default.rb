# frozen_string_literal: true

::Spina::Theme.register do |theme| # rubocop:disable Metrics/BlockLength
  theme.name = 'default'
  theme.title = 'Default'

  theme.layout_parts = %w[current_conference_alert]

  theme.parts = [{
    name: 'text',
    title: 'Text',
    part_type: 'Spina::Parts::Text'
  }, {
    name: 'gallery',
    title: 'Gallery',
    part_type: 'Spina::Parts::ImageCollection'
  }, {
    name: 'constitution',
    title: 'Constitution',
    part_type: 'Spina::Parts::Attachment'
  }, {
    name: 'slides',
    title: 'Slides',
    part_type: 'Spina::Parts::Attachment'
  }, {
    name: 'handout',
    title: 'Handout',
    part_type: 'Spina::Parts::Attachment'
  }, {
    name: 'poster',
    title: 'Poster',
    part_type: 'Spina::Parts::Attachment'
  }, {
    name: 'partner_societies',
    title: 'Partner societies',
    part_type: 'Spina::Parts::Repeater',
    parts: %w[name logo description]
  }, {
    name: 'minutes',
    title: 'Minutes',
    part_type: 'Spina::Parts::Repeater',
    parts: %w[attachment]
  }, {
    name: 'contact',
    title: 'Contact',
    part_type: 'Spina::Parts::Text'
  }, {
    name: 'socials',
    title: 'Socials',
    part_type: 'Spina::Parts::Repeater',
    parts: %w[name location description]
  }, {
    name: 'meetings',
    title: 'Meetings',
    part_type: 'Spina::Parts::Repeater',
    parts: %w[name location description]
  }, {
    name: 'committee_bios',
    title: 'Committee bios',
    part_type: 'Spina::Parts::Repeater',
    parts: %w[name role bio profile_picture]
  }, {
    name: 'sponsors',
    title: 'Sponsors',
    part_type: 'Spina::Parts::Repeater',
    parts: %w[name website logo]
  }, {
    name: 'current_conference_alert',
    title: 'Alert',
    part_type: 'Spina::Parts::Line'
  }, {
    name: 'name',
    title: 'Name',
    part_type: 'Spina::Parts::Line'
  }, {
    name: 'description',
    title: 'Description',
    part_type: 'Spina::Parts::Text'
  }, {
    name: 'attachment',
    title: 'Attachment',
    part_type: 'Spina::Parts::Attachment'
  }, {
    name: 'location',
    title: 'Location',
    part_type: 'Spina::Parts::Line'
  }, {
    name: 'role',
    title: 'Role',
    part_type: 'Spina::Parts::Line'
  }, {
    name: 'bio',
    title: 'Bio',
    part_type: 'Spina::Parts::Text'
  }, {
    name: 'profile_picture',
    title: 'Profile picture',
    part_type: 'Spina::Parts::Image'
  }, {
    name: 'website',
    title: 'Website',
    part_type: 'Spina::Parts::Admin::Conferences::Url'
  }, {
    name: 'logo',
    title: 'Logo',
    part_type: 'Spina::Parts::Image'
  }, {
    name: 'submission_url',
    title: 'Submission URL',
    part_type: 'Spina::Parts::Admin::Conferences::Url'
  }, {
    name: 'submission_email_address',
    title: 'Submission email address',
    part_type: 'Spina::Parts::Admin::Conferences::EmailAddress'
  }, {
    name: 'submission_date',
    title: 'Submission date',
    part_type: 'Spina::Parts::Admin::Conferences::Date'
  }, {
    name: 'submission_text',
    title: 'Submission text',
    part_type: 'Spina::Parts::Line'
  }
]

  theme.view_templates = [{
    name: 'homepage',
    title: 'Homepage',
    parts: %w[gallery]
  }, {
    name: 'information',
    title: 'Information',
    description: 'Contains general information',
    parts: %w[text]
  }, {
    name: 'committee',
    title: 'Committee',
    description: 'Contains committee bios',
    parts: %w[text committee_bios]
  }, {
    name: 'about',
    title: 'About',
    description: 'Contains information about the society',
    parts: %w[text constitution minutes partner_societies contact]
  }, {
    name: 'show',
    title: 'Blank',
    description: 'Blank template',
    parts: %w[]
  }]

  theme.custom_pages = [{
    name: 'homepage',
    title: 'Homepage',
    deletable: false,
    view_template: 'homepage'
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

  theme.plugins = ['conferences']
end
