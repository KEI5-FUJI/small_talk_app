module SessionsHelper
  def log_in(user)
    session[:uid] = user.uid
  end

  def current_user
    if (user_id = session[:uid])
      @current_user ||= User.find_by(uid: user_id) 
    elsif (user_id = cookies.signed[:uid])
      user = User.find_by(uid: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def forget(user)
    user.forget
    cookies.delete(:uid)
    cookies.delete(:remember_token)
  end

  def remember
    user.remember
    cookies.permanent.signed[:uid] = user.uid
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    forget(current_user)
    session.delete(:uid)
    @current_user = nil
  end
end
