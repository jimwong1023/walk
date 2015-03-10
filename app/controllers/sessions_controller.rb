class SessionsController < ApplicationController
  def create
    flash[:errors] = []
    if params[:session]
      user = User.find_by_email(params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        login user
        return redirect_to user_path user
      else
        flash[:errors] << "Invalid email or password"
      end
    end
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end