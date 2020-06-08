# frozen_string_literal: true

require 'spec_helper'

login_data = ConfigHelper.get('enterprise_login_data')

login_data[:enterprise].each do |portal|
  describe "Login to #{portal[:portal]}", :login, :enterprise, :smoke do
    before :all do
      Onboarding.skip_button_click
      CloudList.get_started_button_click
    end

    it 'Input portal address' do
      OnlyofficeEnterpriseLogin.portal_address_textfield_fill portal[:portal]
      OnlyofficeEnterpriseLogin.next_button_click
    end

    it 'Input user data' do
      OnlyofficeEnterpriseLogin.email_textfield_fill portal[:login]
      OnlyofficeEnterpriseLogin.password_textfield_fill portal[:pass]
    end

    it('Sign In') { OnlyofficeEnterpriseLogin.sign_in_button_click }

    it 'Check the portal address after login ' do
      expected_portal = CloudTopToolBar.account_sub_title_text_value
      expect(expected_portal).to eq(portal[:portal])
    end
  end
end

login_data[:google].each do |portal|
  describe "Login through Google to #{portal[:portal]}", :login, :enterprise, :smoke do
    before :all do
      Onboarding.skip_button_click
      CloudList.get_started_button_click
    end

    it 'Input portal address' do
      OnlyofficeEnterpriseLogin.portal_address_textfield_fill portal[:portal]
      OnlyofficeEnterpriseLogin.next_button_click
    end

    it 'Tap Google account' do
      OnlyofficeEnterpriseLogin.google_button_click
      sleep 2
      OnlyofficeEnterpriseLogin.google_account_button_click
    end

    it 'Check the portal address after login ' do
      expected_portal = CloudTopToolBar.account_sub_title_text_value
      expect(expected_portal).to eq(portal[:portal])
    end
  end
end

login_data[:facebook].each do |portal|
  describe "Login through Facebook to  #{portal[:portal]}", :login, :enterprise, :smoke do
    before :all do
      Onboarding.skip_button_click
      CloudList.get_started_button_click
    end

    it 'Input portal address' do
      OnlyofficeEnterpriseLogin.portal_address_textfield_fill portal[:portal]
      OnlyofficeEnterpriseLogin.next_button_click
    end

    it 'Tap Facebook account' do
      OnlyofficeEnterpriseLogin.facebook_button_click
      OnlyofficeEnterpriseLogin.fb_login_textfield_fill portal[:login]
      OnlyofficeEnterpriseLogin.fb_pass_textfield_fill portal[:pass]
      OnlyofficeEnterpriseLogin.fb_log_in_button_click
      OnlyofficeEnterpriseLogin.continue_button_click
    end

    it 'Check the portal address after login ' do
      expected_portal = CloudTopToolBar.account_sub_title_text_value
      expect(expected_portal).to eq(portal[:portal])
    end
  end
end