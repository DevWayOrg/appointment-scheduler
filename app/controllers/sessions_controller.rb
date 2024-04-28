class SessionsController < ApplicationController
  def new; end

  def create
    user_info = request.env['omniauth.auth']
    email = user_info.info.email
    name = user_info.info.name

    case User::SignInWithGoogle.call(email:, name:)
    in Solid::Success(user:)
      sign_in(user)
      redirect_to dashboard_path
    in Solid::Failure(input:)
      flash[:error] = input.errors[:base].join(', ')
      redirect_to root_path
    end
  end
end
