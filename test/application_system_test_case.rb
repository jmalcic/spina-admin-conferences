# frozen_string_literal: true

require 'test_helper'

# Needed because Selenium not required when running via Rake test
require 'selenium-webdriver' unless defined? Selenium

ActiveSupport.on_load :action_dispatch_system_test_case do
  ActionDispatch::SystemTesting::Server.silence_puma = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ::Spina::Engine.routes.url_helpers

  def self.driver_capabilities
    Selenium::WebDriver::Remote::Capabilities.firefox(browser_version: 'latest',
                                                      'bstack:options': {
                                                        os: 'OS X',
                                                        os_version: 'Big Sur',
                                                        resolution: '1920x1080',
                                                        local: true,
                                                        local_identifier: ENV['BROWSERSTACK_LOCAL_IDENTIFIER'],
                                                        project_name: ENV['BROWSERSTACK_PROJECT_NAME'],
                                                        build_name: ENV['BROWSERSTACK_BUILD_NAME'],
                                                        user_name: ENV['BROWSERSTACK_USERNAME'],
                                                        access_key: ENV['BROWSERSTACK_ACCESS_KEY']
                                                      })
  end
  driven_by :selenium, using: :remote, options: { url: 'https://hub-cloud.browserstack.com/wd/hub', capabilities: driver_capabilities }

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
