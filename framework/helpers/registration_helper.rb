# frozen_string_literal: true

require_relative '../../framework/constants/id.rb'
require_relative '../../framework/constants/const_index.rb'
require_relative '../../framework/tools/appium_extension.rb'
require_relative '../../spec/spec_helper.rb'
include AppiumExtension

# Module contain different classes of help
module Helpers
  # Class contains data help methods for Registration portal
  class DataPortals
    def self.locale_language(tl_domain)
      case tl_domain
      when 'eu', 'info'
        { 'locale' => 'RU', 'language' => 'RU' }
      when 'com'
        { 'locale' => 'EN', 'language' => 'EN' }
      when 'sg'
        { 'locale' => 'VN', 'language' => 'vi' }
      else
        'Languages and localization are not supported'
      end
    end

    def self.change_domain_to_info
      fill_form id: ID::REGISTRATION_NAME, data: 'getinfoportal00000'
      element( id: ID::REGISTRATION_NAME).clear
    end
  end
end
