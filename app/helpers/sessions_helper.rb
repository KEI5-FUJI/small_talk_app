module SessionsHelper

  def log_in(user)
    session[:id] = user.id
  end

  def current_user
    if (user_id = session[:id])
      @current_user ||= User.find_by(id: user_id) 
    elsif (user_id = cookies.signed[:id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def forget(user)
    user.forget
    cookies.delete(:id)
    cookies.delete(:remember_token)
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    forget(current_user)
    session.delete(:id)
    @current_user = nil
  end

  def current_user?(user)
      user && user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
