module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def log_out
    forget current_user
    reset_session
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user? user
    user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_fullpath if request.get?
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
