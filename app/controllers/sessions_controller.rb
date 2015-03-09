class SessionsController < ApplicationController
  def create
    flash[:notice] = []
    if params[:session]
      if user = User.find_by_email(params[:session][:email].downcase)
        login user
        return redirect_to user_path user
      else
        flash[:notice] << "Invalid email or password"
      end
    end
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end