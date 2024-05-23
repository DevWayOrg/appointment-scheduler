class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    appointment = Appointment::Schedule::Input.new(user: current_user)
    case [ Appointment::List.call(user: current_user, filter: :past), Appointment::List.call(user: current_user, filter: :future) ]
    in [Solid::Success(appointments: past_appointments), Solid::Success(appointments: future_appointments)]
      render locals: { appointment:, past_appointments:, future_appointments: }
    end
  end
end
