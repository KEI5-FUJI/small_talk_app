class SessionsController < ApplicationController
  def create
    unless request.env['onmiauth.auth'][:uid]
      flash[:danger] = '連携に失敗しました。'
      redirect_to root_url
    end
    user_data=request.env['omniauth.auth']
    user = User.find_by(uid: user_data[:uid])
    if user
      log_in user
      remember user
      flash[:success] = "ログインしました"
      redirect_to tasks_path
    else
      user = User.new(
        uid: user_data[:uid],
        nickname: user_data[:info][:nickname],
        name: user_data[:info][:name],
        image: user_data[:info][:image],
      )
    end
    if user.save
      log_in user
      remember user
      flash[:success] = 'ユーザー登録成功'
      redirect_to tasks_url
    else
      flash[:danger] = '予期せぬエラーが発生しました'
      redirect_to root_url
    end
  end

  def logout
    logout if logged_in?
    flash[:success] = 'ログアウトしました'
    redirect_to root_url
  end
end
