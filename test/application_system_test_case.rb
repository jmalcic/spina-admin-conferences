# frozen_string_literal: true

require 'test_helper'

# Needed because Selenium not required when running via Rake test
require 'selenium-webdriver' unless defined? Selenium

ActiveSupport.on_load :action_dispatch_system_test_case do
  ActionDispatch::SystemTesting::Server.silence_puma = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ::Spina::Engine.routes.url_helpers

  def self.start_local_instance
    @browserstack_local = BrowserStack::Local.new(ENV['BROWSERSTACK_ACCESS_KEY'])
    @browserstack_local.start('forcelocal' => 'true')
    Minitest.after_run { @browserstack_local.stop if @browserstack_local.isRunning }
  end

  def self.driver_capabilities
    Selenium::WebDriver::Remote::Capabilities.firefox(browser_version: 'latest',
                                                      'bstack:options': {
                                                        os: 'OS X',
                                                        os_version: 'Big Sur',
                                                        resolution: '1920x1080',
                                                        local: true,
                                                        project_name: Spina::Admin::Conferences.name,
                                                        build_name: Spina::Admin::Conferences::VERSION,
                                                        user_name: ENV['BROWSERSTACK_USER'],
                                                        access_key: ENV['BROWSERSTACK_ACCESS_KEY'],
                                                      })
  end

  start_local_instance

  driven_by :selenium, using: :remote,
                       options: { url: 'https://hub-cloud.browserstack.com/wd/hub', capabilities: driver_capabilities }

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
