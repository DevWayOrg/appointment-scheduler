class AppointmentsController < ApplicationController
  def create
    appointment_params = params.require(:appointment).permit(:time, :date, :name, :reason).with_defaults(user: current_user)

    case Appointment::Schedule.call(appointment_params)
    in Solid::Success(appointment: _)
      flash[:success] = "Appointment scheduled successfully"
      redirect_to dashboard_path
    in Solid::Failure(input:)
      render "dashboard/index", locals: { appointment: input, past_appointments: [], future_appointments: [] }, status: :unprocessable_entity
    end
  end

  def destroy
    case Appointment::Remove.call(user: current_user, id: params[:id])
    in Solid::Success(appointment: _)
      flash[:success] = "Appointment removed successfully"
      redirect_to dashboard_path
    in Solid::Failure(input: _)
      flash[:error] = "Something didn't work"
      redirect_to dashboard_path
    end
  end
end
