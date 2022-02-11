class TasksController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
    @task = current_user.tasks.build
    @feed_items = current_user.feed.all
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを作成しました。"
      redirect_to tasks_url
    else
      render 'tasks/index'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = "タスクを削除しました。"
    redirect_to request.referrer || root_url
  end

  private
    def task_params
      params.require(:task).permit(:content)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
