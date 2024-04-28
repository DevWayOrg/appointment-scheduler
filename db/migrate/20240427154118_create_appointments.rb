class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :name
      t.string :reason
      t.timestamp :date

      t.timestamps
    end
  end
end
