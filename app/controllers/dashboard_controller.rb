class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    appointment = Appointment::Schedule::Input.new
    render locals: { appointment: }
  end
end
