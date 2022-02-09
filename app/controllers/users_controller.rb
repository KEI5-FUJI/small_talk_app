class UsersController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_mail
      flash[:success] = "アカウント有効化のメールを送信しました。メールをチェックしてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
    else
      render 'edit'
    end
  end

  def index
    follows_ids = current_user.following_ids
    @following_users = User.where(id: follows_ids)
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end

  def following
    @title = "フォロ中のユーザー"
    @user = User.find(parms[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user = User.find(parms[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user =User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end