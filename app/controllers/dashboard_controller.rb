class DashboardController < ApplicationController
  def index
    appointment = Appointment.new
    render locals: { appointment: }
  end
end
