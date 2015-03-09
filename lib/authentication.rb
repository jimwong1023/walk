module Authentication

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login(user)
    session[:user_id] = user.id
  end
end