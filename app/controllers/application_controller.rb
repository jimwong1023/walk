 class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Authentication

  helper_method :current_user, :is_logged_in?

  private

	def require_login
    unless is_logged_in?
      flash[:errors] = ["Please log in"]
      redirect_to root_url
    end
	end
end
