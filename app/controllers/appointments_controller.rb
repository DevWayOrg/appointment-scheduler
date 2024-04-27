class AppointmentsController < ApplicationController
  def create
    flash[:success] = 'Appointment scheduled successfully'
    redirect_to root_path
  end
end
