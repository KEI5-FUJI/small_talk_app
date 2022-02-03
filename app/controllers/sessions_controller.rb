class SessionsController < ApplicationController
  include SessionsHelper
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_beck_or user
    else 
      flash[:danger] = "メールアドレスとパスワードの組み合わせが間違っています"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end

  def new
  end
end
