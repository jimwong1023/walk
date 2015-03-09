class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      login user
      redirect_to user_path user
    else
      flash[:notice] = user.errors.full_messages
      redirect_to root_path
    end
  end

  def show
    @business = Business.new
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end