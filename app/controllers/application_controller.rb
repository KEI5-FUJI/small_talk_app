class ApplicationController < ActionController::Base
  include SessionsHelper
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end

  def not_logged_in_user
    if logged_in?
      store_location
      flash[:danger] = "すでにログイン済みです"
      redirect_to user_path(id: current_user.id)
    end
  end
end
