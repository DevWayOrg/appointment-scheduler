require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  test 'visiting the register page' do
    visit root_path

    assert_text 'Login with Google'
  end

  test 'login with google and being redirected to dashboard' do
    OmniAuth.config.test_mode = true
    name = 'John Doe'
    email = 'john@doe.com'
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(info: { name:, email: })

    visit root_path

    click_on 'Login with Google'

    assert current_path, dashboard_path
  end

  test 'login with google is broken' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      info: { name: '', email: '' }
    )

    visit root_path

    click_on 'Login with Google'

    assert current_path, root_path
  end

end
