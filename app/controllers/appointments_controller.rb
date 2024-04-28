class AppointmentsController < ApplicationController
  def create
    appointment_params = params.require(:appointment).permit(:time, :date, :name, :reason)

    case Appointment::Schedule.call(appointment_params)
      in Solid::Success(appointment: _)
        flash[:success] = 'Appointment scheduled successfully'
        redirect_to dashboard_path
      in Solid::Failure(input:)
        render 'dashboard/index', locals: { appointment: input }, status: :unprocessable_entity
      end
  end
end
