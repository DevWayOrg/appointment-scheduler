require 'application_system_test_case'

class ScheduleAppointmentsTest < ApplicationSystemTestCase
  test 'visiting the dashboard' do
    visit root_path

    assert_selector 'h1', text: 'Dashboard'
  end

  test 'scheduling an appointment' do
    visit root_path

    fill_in 'Name', with: 'John Doe'
    fill_in 'Reason', with: 'Check-up'
    fill_in 'Date', with: Date.today
    time = Time.new + 1.hour
    fill_in 'Time', with: time.strftime("%I:%M%p")

    click_on 'Schedule'

    assert_selector 'p', text: 'Appointment scheduled successfully'
  end

  test 'not scheduling an appointment when date is less than today' do
    visit root_path

    fill_in 'Name', with: 'John Doe'
    fill_in 'Reason', with: 'Check-up'
    fill_in 'Date', with: Date.new(2021, 1, 1)
    fill_in 'Time', with: '10:00AM'

    click_on 'Schedule'

    assert_selector 'p', text: 'Date must be greater than or equal to today'
  end

  test 'not scheduling an appointment when date is today and time is less than current time' do
    visit root_path

    fill_in 'Name', with: 'John Doe'
    fill_in 'Reason', with: 'Check-up'
    fill_in 'Date', with: Date.today
    fill_in 'Time', with: (Time.new - 1.hour).strftime("%I:%M%p")

    click_on 'Schedule'

    assert_selector 'p', text: 'Time must be greater than now'
  end
end
