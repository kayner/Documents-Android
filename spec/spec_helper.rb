# frozen_string_literal: true

require 'appium_lib'
require 'rspec'

# Core
require_relative '../framework/core/adb'
require_relative '../framework/core/appium_driver'
require_relative '../framework/core/appium_server'
require_relative '../framework/core/base_page_object'
require_relative '../framework/core/page_object'
require_relative '../framework/core/test_instance'

# Data
require_relative '../framework/data/consts'

# Helpers
require_relative '../framework/helpers/config_helper'

# Modules
require_relative '../framework/modules/modules'

RSpec.configure do |config|
  ConfigHelper.load
  Selenium::WebDriver.logger.level = :error
  config_file = 'test_devices_config'

  config.before :all do
    device_config = ConfigHelper.find_config_by_udid config_file, ENV['udid']
    capabilities = ConfigHelper.load_capabilities[:caps]
    capabilities.merge device_config[:specified_capabilities]
    capabilities[:deviceName] = device_config[:name]
    capabilities[:udid] = device_config[:udid]

    @test_instance = TestInstance.new device_config[:udid], capabilities,
                                      device_config[:appium_port],
                                      device_config[:system_port]
    @test_instance.init
    @test_instance.run
    ENV['server_state'] = '1'
  end

  config.after :all do
    @test_instance.stop_driver
  end
end
