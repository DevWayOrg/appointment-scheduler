class AddGoogleCalendarIdAndScheduledLinkToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :google_calendar_id, :string
    add_column :appointments, :scheduled_link, :string
  end
end
