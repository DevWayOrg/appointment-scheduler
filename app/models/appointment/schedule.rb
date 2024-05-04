module Appointment
  class Schedule < Solid::Process
    deps do
      attribute :today, default: Time.zone.now
      attribute :repository, default: Repository
      attribute :google_calendar_worker, default: SendToGoogleCalendar
    end

    input do
      attribute :name, :string
      attribute :reason, :string
      attribute :date, :date
      attribute :time, :time
      attribute :user

      validates :name, :reason, :date, :time, presence: true
      validates :user, instance_of: User::Repository
    end


    def call(attributes)
      rollback_on_failure {
        Given(attributes)
          .and_then(:check_if_appointment_is_more_or_equal_than_now)
          .and_then(:create_an_appointment)
          .and_then(:send_an_appointment_to_google_calendar)
      }
    end

    private

    def check_if_appointment_is_more_or_equal_than_now(date:, time:, **)
      if date.to_date < deps.today.to_date
        input.errors.add(:date, message: 'must be greater than or equal to today')
        return Failure(:invalid_input, input:)
      end

      datetime = DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0, Time.zone.formatted_offset)

      if before_or_now?(datetime:)
        input.errors.add(:time, message: 'must be greater than now')
        return Failure(:invalid_input, input:)
      end


      Continue(datetime:, **)
    end

    def before_or_now?(datetime:)
      return false if datetime.to_date > deps.today.to_date

      # I'll need to use a workaround, let's check if it's going to work

      now = Time.zone.now

      return true if datetime.hour < now.hour

      return true if datetime.hour == now.hour && datetime.min < now.min

      false
    end

    def create_an_appointment(name:, reason:, datetime:, user:, **)
      user_id = user.id
      input = { name:, reason:, date: datetime, user_id: }
      output = deps.repository.insert(input)
      appointment = output.rows[0][0]
      Continue(appointment:, **)
    end

    def send_an_appointment_to_google_calendar(appointment:,**)
      deps.google_calendar_worker.perform_later(appointment)
      Success(:scheduled_appointment, appointment:)
    end
  end
end
