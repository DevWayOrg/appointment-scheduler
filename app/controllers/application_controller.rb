class ApplicationController < ActionController::Base
  add_flash_types :success, :error

  private

  helper_method def user_signed_in?
    current_user.present?
  end

  helper_method def current_user
    @current_user ||= User::Repository.find_by(id: current_user_id)
  end

  helper_method def current_user_id
    session[:user_id]
  end

  helper_method def current_user_id=(id)
    session[:user_id] = id
  end

  def authenticate_user!
    return if user_signed_in?

    redirect_to root_path, error: 'You must be signed in to access this page'
  end

  def sign_in(user)
    reset_session

    self.current_user_id = user.id
  end

  def sign_out
    reset_session
  end
end
