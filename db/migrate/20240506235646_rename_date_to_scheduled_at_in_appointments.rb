class RenameDateToScheduledAtInAppointments < ActiveRecord::Migration[7.1]
  def change
    rename_column :appointments, :date, :scheduled_at
  end
end
