# frozen_string_literal: true

require 'test_helper'

ActiveSupport.on_load :action_dispatch_system_test_case do
  ActionDispatch::SystemTesting::Server.silence_puma = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ::Spina::Engine.routes.url_helpers

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 800]

  def before_setup
    super
    upload_files
  end

  def after_teardown
    super
    remove_uploaded_files
  end

  def upload_files
    Spina::Image.all.each do |image|
      unless image.file.attached?
        file_fixture('dubrovnik.jpeg').then { |fixture| image.file.attach io: fixture.open, filename: fixture.basename }
      end
    end
    Spina::Attachment.all.each do |attachment|
      unless attachment.file.attached?
        file_fixture('handout.pdf').then { |fixture| attachment.file.attach io: fixture.open, filename: fixture.basename }
      end
    end
  end

  def remove_uploaded_files
    Spina::Image.all.each { |image| image.file.purge }
    Spina::Attachment.all.each { |attachment| attachment.file.purge }
  end
end
