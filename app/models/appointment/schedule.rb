module Appointment
  class Schedule < Solid::Process
    deps do
      attribute :today, default: DateTime.now
      attribute :repository, default: Repository
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
      }
    end

    private

    def check_if_appointment_is_more_or_equal_than_now(date:, time:, **)
      if before_today?(date:)
        input.errors.add(:date, message: 'must be greater than or equal to today')
        return Failure(:invalid_input, input:)
      end

      if before_or_now?(date:, time:)
        input.errors.add(:time, message: 'must be greater than now')
        return Failure(:invalid_input, input:)
      end

      Continue(date:, time:, **)
    end

    def before_today?(date:, **)
      return true if date.day < deps.today.day && date.month <= deps.today.month && date.year <= deps.today.year

      false
    end

    def before_or_now?(date:, time:)
      return false if date.day > deps.today.day && date.month >= deps.today.month && date.year >= deps.today.year

      return true if time.hour <= deps.today.hour && time.min <= deps.today.min

      false
    end

    def create_an_appointment(name:, reason:, time:, date:, user:, **)
      date_field = DateTime.new(date.year, date.month, date.day, time.hour, time.min)
      user_id = user.id
      input = { name:, reason:, date: date_field, user_id: }
      output = deps.repository.insert(input)
      Continue(appointment: output)
    end
  end
end
