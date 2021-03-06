# frozen_string_literal: true

# PageObject for Onlyoffice Personal Login
class OnlyofficePersonalLogin < BasePageObject
  textfield 'email', id: 'login_personal_portal_email_edit'
  textfield 'password', id: 'login_personal_portal_password_edit'
  button 'sign_in', id: 'login_personal_signin_button'
  button 'facebook', id: 'login_social_facebook_button'
  textfield 'fb_login', xpath: "//android.widget.EditText[@index='0']"
  textfield 'fb_pass', xpath: "//android.widget.EditText[@index='1']"
  button 'fb_log_in', xpath: '//android.widget.Button'
  button 'continue', xpath: "//android.widget.Button[@text='Continue']"

  button 'google', id: 'login_social_google_button'
  button 'google_account', xpath: "//android.widget.LinearLayout[@index='0']"

  text 'description', id: 'login_personal_info_text'
  button 'create_portal', id: 'login_personal_signup_button'

  def self.add_cloud(cloud)
    PortalTypeSwitcher.personal_button_click
    email_textfield_fill cloud[:login]
    password_textfield_fill cloud[:pass]
    sign_in_button_click
  end

  def self.login_after_logout(cloud)
    password_textfield_fill cloud[:pass]
    sign_in_button_click
  end
end
