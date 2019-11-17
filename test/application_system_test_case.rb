# frozen_string_literal: true

require 'test_helper'

ActiveSupport.on_load :action_dispatch_system_test_case do
  ActionDispatch::SystemTesting::Server.silence_puma = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ::Spina::Engine.routes.url_helpers

  def url_options
    default_url_options.merge(host: Capybara.app_host)
  end

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 800]
end
