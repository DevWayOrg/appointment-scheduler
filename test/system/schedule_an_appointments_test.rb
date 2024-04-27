require "application_system_test_case"

class ScheduleAnAppointmentsTest < ApplicationSystemTestCase
  test "visiting the dashboard" do
    visit root_path

    assert_selector 'h1', text: 'Dashboard'
  end

  test "scheduling an appointment" do
    visit root_path

    fill_in 'Name', with: 'John Doe'
    fill_in 'Reason', with: 'Check-up'
    fill_in 'Date', with: Date.new(2021, 1, 1)
    fill_in 'Time', with: '10:00AM'

    click_on 'Schedule'

    assert_selector 'p', text: 'Appointment scheduled successfully'
  end
end
