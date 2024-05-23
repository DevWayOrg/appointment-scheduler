class Appointment::List < Solid::Process
  deps do
    attribute :repository, default: ::Appointment::Repository
  end

  input do
    attribute :user
    attribute :filter, default: :upcoming

    validates :filter, inclusion: { in: [:future, :past] }
    validates :user, instance_of: User::Repository
  end

  def call(attributes)
    Given(attributes)
      .and_then(:list_appointments)
      .and_expose(:appointment_records, %i[appointments])
  end

  def list_appointments(user:, filter:)
    appointments = deps.repository.where(user_id: user.id)
    if filter == :past
      appointments = appointments.where("scheduled_at < ?", Time.zone.now)
    else
      appointments = appointments.where("scheduled_at >= ?", Time.zone.now)
    end

    Continue(appointments:)
  end
end
