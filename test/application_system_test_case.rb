# frozen_string_literal: true

require 'test_helper'

# Needed because Selenium not required when running via Rake test
require 'selenium-webdriver' unless self.class.const_defined? :Selenium

ActiveSupport.on_load :action_dispatch_system_test_case do
  ActionDispatch::SystemTesting::Server.silence_puma = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ::Spina::Engine.routes.url_helpers

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 800]

  setup do
    @user = spina_users :joe
    visit admin_login_path
    within '.login-fields' do
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password'
    end
    click_on 'Login'
  end
end

Capybara.default_max_wait_time = 5
