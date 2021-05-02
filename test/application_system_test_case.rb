# frozen_string_literal: true

require 'test_helper'

# Needed because Selenium not required when running via Rake test
require 'selenium-webdriver' unless self.class.const_defined? :Selenium

ActiveSupport.on_load :action_dispatch_system_test_case do
  ActionDispatch::SystemTesting::Server.silence_puma = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ::Spina::Engine.routes.url_helpers

  def self.start_local_instance
    @browserstack_local = BrowserStack::Local.new(Rails.application.credentials.dig(:browserstack, :key))
    @browserstack_local.start('forcelocal' => 'true')
    Minitest.after_run { @browserstack_local.stop if @browserstack_local.isRunning }
  end

  def self.driver_capabilities
    Selenium::WebDriver::Remote::Capabilities.firefox(version: 'latest',
                                                      os: 'OS X',
                                                      os_version: 'Big Sur',
                                                      resolution: '1920x1080',
                                                      project: Spina::Admin::Conferences.name,
                                                      build: Spina::Admin::Conferences::VERSION,
                                                      'browserstack.user': Rails.application.credentials.dig(:browserstack, :user),
                                                      'browserstack.key': Rails.application.credentials.dig(:browserstack, :key),
                                                      'browserstack.local': true)
  end

  start_local_instance

  driven_by :selenium, using: :remote,
                       options: { url: 'https://hub-cloud.browserstack.com/wd/hub', desired_capabilities: driver_capabilities }

  setup do
    execute_script <<~JS
      browserstack_executor: {"action": "setSessionName", "arguments": {"name": "#{name}"}}
    JS
    page.current_window.maximize
    @user = spina_users :joe
    visit admin_login_path
    within '.login-fields' do
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password'
    end
    click_on 'Login'
  end

  teardown do
    if passed?
      execute_script <<~JS
        browserstack_executor: {"action": "setSessionStatus", "arguments": {"status": "passed"}}
      JS
    else
      message = ActiveSupport::JSON.encode(failures.first.message)
      execute_script <<~JS
        browserstack_executor: {"action": "setSessionStatus", "arguments": {"status": "failed", "reason": #{message}}}
      JS
    end
    page.driver.quit
  end
end

Capybara.default_max_wait_time = 5
