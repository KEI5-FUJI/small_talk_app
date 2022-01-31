class TasksController < ApplicationController
  @task_value="タスクを入力してください"
  @button_value="投稿"

  def index
    @all_tasks = Task.all
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:seccess] = "タスクを作成しました。"
      redirect_to tasks_url
    else
      render 'tasks/index'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:seccess] = "タスクを削除しました。"
    redirect_to tasks_url
  end

  private
    def task_params
      params.require(:task).permit(:content)
    end
    
end
