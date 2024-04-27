class Appointment::Schedule < Solid::Process
  input do
    attribute :name, :string
    attribute :reason, :string
    attribute :date, :date
    attribute :time, :time

    validates :name, :reason, :date, :time, presence: true
  end

  deps do
    attribute :today, default: DateTime.now
  end

  def call(attributes)
    Given(attributes).and_then(:check_if_appointment_is_more_or_equal_than_now)
  end

  def check_if_appointment_is_more_or_equal_than_now(date:, time:, **)
    is_before_today = date.day < deps.today.day && date.month < deps.today.month && date.year < deps.today.year
    if is_before_today
      input.errors.add(:date, message: 'must be greater than or equal to today')
      return Failure(:invalid_input, input:)
    end

    if date.day == deps.today.day && date.month == deps.today.month && date.year == deps.today.year && (time.hour < deps.today.hour || time.hour == deps.today.hour && time.min < deps.today.minute)
      input.errors.add(:time, message: 'must be greater than now')
      return Failure(:invalid_input, input:)
    end

    Success(:appointment_verified, appointment: {}, **)
  end
end
