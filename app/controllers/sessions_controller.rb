class SessionsController < ApplicationController
  def new; end

  def create
    user_info = request.env['omniauth.auth']

    email = user_info.info.email
    name = user_info.info.name
    access_token = user_info.credentials.token
    expires_at = user_info.credentials.expires_at
    refresh_token = user_info.credentials.refresh_token

    input = { name:, email:, access_token:, refresh_token:, expires_at: }

    case User::SignInWithGoogle.call(input)
    in Solid::Success(user:)
      sign_in(user)
      redirect_to dashboard_path
    in Solid::Failure(input:)
      flash[:error] = input.errors[:base].join(', ')
      redirect_to root_path
    end
  end
end
