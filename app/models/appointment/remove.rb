class Appointment::Remove < Solid::Process
  deps do
    attribute :repository, default: ::Appointment::Repository
  end

  input do
    attribute :id, :integer

    attribute :user

    validates :user, instance_of: ::User::Repository
  end

  def call(attributes)
    rollback_on_failure {
      Given(attributes)
        .and_then(:remove_appointment_from_google_calendar)
        .and_expose(:removed_appointment, %i[appointment])
    }
  end

  def remove_appointment_from_google_calendar(user:, id:)
    appointment = deps.repository.find_by(id:, user_id: user.id)
    appointment.destroy
    ::Appointment::RemoveFromGoogleCalendar.perform_later(appointment.google_calendar_id, user.id)
    Continue(appointment:)
  end
end
