require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "visiting the register page" do
    visit root_path

    assert_text "Login with Google"
  end

  test "login with google and being redirected to dashboard" do
    OmniAuth.config.test_mode = true
    name = "John Doe"
    email = "john@doe.com"
    auth_input = {
      info: { name:, email: },
      credentials: {
        token: SecureRandom.hex(5),
        refresh_token: SecureRandom.hex(5),
        expires_at: Time.zone.now.to_i + 1.week
      }
    }
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(auth_input)

    visit root_path

    click_on "Login with Google"

    assert current_path, dashboard_path
  end

  test "login with google is broken" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      info: { name: "", email: "" },
      credentials: { token: "", refresh_token: "", expires_at: Time.zone.now.to_i }
    )

    visit root_path

    click_on "Login with Google"

    assert current_path, root_path
  end
end
