# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require_relative 'spec/spec_helper'

def format_opts(device, included_tags, excluded_tags)
  device.gsub!(' ', '_').downcase!
  tag_format = ''
  included_tags.each { |tag| tag_format += "-t #{tag} " }
  excluded_tags.each { |tag| tag_format += "-t ~@#{tag} " }
  report_path = "reports/#{device}_#{Time.now.strftime '%d-%m_%H-%M-%S'}.html"
  "#{tag_format} -f html -o #{report_path}"
end

namespace :run do
  desc 'Run tests on all connected physical devices and emulators'
  task :parallel do
    adb = ADB.new
    adb.devices.each do |udid|
      `gnome-terminal -- rake run:single udid=#{udid}`
    end
  end

  desc 'Run tests on device/emulator. Need udid arg for working'
  task :single do
    config_name = 'test_devices_config'
    RSpec::Core::RakeTask.new(:spec) do |t|
      ConfigHelper.load
      config = ConfigHelper.find_config_by_udid config_name, ENV['udid']
      t.rspec_opts = format_opts config[:name], config[:included_tags], config[:excluded_tags]
    end

    begin
      Rake::Task['spec'].execute
    ensure
      puts 'Press any key for exit...'
      STDIN.gets
    end
  end
end
