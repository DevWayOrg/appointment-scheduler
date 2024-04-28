class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    appointment = Appointment::Schedule::Input.new(user: current_user)
    render locals: { appointment: }
  end
end
