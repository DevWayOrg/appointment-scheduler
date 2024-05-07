require "application_system_test_case"

class ScheduleAppointmentsTest < ApplicationSystemTestCase
  setup do
    OmniAuth.config.test_mode = true
    user = User::Repository.create(name: "John Doe", email: "john@doe.com")
    now = Time.zone.now.to_i + 1.week
    auth_input = {
      info: { name: user.name, email: user.email },
      credentials: {
        token: SecureRandom.hex(5),
        refresh_token: SecureRandom.hex(5), expires_at: now
      }
    }
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(auth_input)
  end

  def sign_in
    visit root_path
    click_on "Login with Google"

    assert current_path, dashboard_path

    sleep 1
  end

  test "visiting the dashboard without signing in redirects to register page" do
    visit dashboard_path

    assert_text "You must be signed in to access this page"
    assert current_path, root_path
  end

  test "visiting the dashboard" do
    sign_in

    visit dashboard_path

    assert_selector "h1", text: "Dashboard"
  end

  test "scheduling an appointment" do
    sign_in

    visit dashboard_path

    fill_in "Name", with: "John Doe"
    fill_in "Reason", with: "Check-up"
    fill_in "Date", with: Date.today
    time = Time.current + 1.hour
    fill_in "Time", with: time.strftime("%I:%M%p")

    click_on "Schedule"

    assert_selector "p", text: "Appointment scheduled successfully"
  end

  test "scheduling an appointment when it's 01PM" do
    travel_to (Time.current.beginning_of_day + 12.hours) do
      sign_in

      visit dashboard_path

      fill_in "Name", with: "John Doe"
      fill_in "Reason", with: "Check-up"
      fill_in "Date", with: Date.today
      time = "01:00PM"
      fill_in "Time", with: time

      click_on "Schedule"

      assert_selector "p", text: "Appointment scheduled successfully"

      appointment = Appointment::Repository.last

    assert_equal appointment.scheduled_at.strftime("%I:%M%p"),  "01:00PM"
    end
  end

  test "not scheduling an appointment when date is less than today" do
    sign_in

    visit dashboard_path

    fill_in "Name", with: "John Doe"
    fill_in "Reason", with: "Check-up"
    fill_in "Date", with: Date.new(2021, 1, 1)
    fill_in "Time", with: "10:00AM"

    click_on "Schedule"

    assert_selector "p", text: "Date must be greater than or equal to today"
  end

  test "not scheduling an appointment when date is today and time is less than current time" do
    sign_in

    visit dashboard_path

    fill_in "Name", with: "John Doe"
    fill_in "Reason", with: "Check-up"
    fill_in "Date", with: Date.today
    fill_in "Time", with: (Time.current - 1.hour).strftime("%I:%M%p")

    click_on "Schedule"

    assert_selector "p", text: "Time must be greater than now"
  end

  test "not scheduling an appointment when date is today and time is less than current time and current time is 2AM" do
    travel_to(Time.current.beginning_of_day + 2.hours) do
      sign_in

      visit dashboard_path

      fill_in "Name", with: "John Doe"
      fill_in "Reason", with: "Check-up"
      fill_in "Date", with: Date.today
      fill_in "Time", with: (Time.current - 1.hour).strftime("%I:%M%p")

      click_on "Schedule"

      assert_selector "p", text: "Time must be greater than now"
    end
  end

  test "not scheduling an appointment when date is today and time is less than current time and current time is almost midnight" do
    travel_to(Time.current.end_of_day) do
      sign_in

      visit dashboard_path

      fill_in "Name", with: "John Doe"
      fill_in "Reason", with: "Check-up"
      fill_in "Date", with: Date.today
      fill_in "Time", with: (Time.current - 1.hour).strftime("%I:%M%p")

      click_on "Schedule"

      assert_selector "p", text: "Time must be greater than now"
    end
  end
end
