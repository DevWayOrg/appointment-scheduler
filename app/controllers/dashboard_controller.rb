class DashboardController < ApplicationController
  def index
    appointment = Appointment::Schedule::Input.new
    render locals: { appointment: }
  end
end
