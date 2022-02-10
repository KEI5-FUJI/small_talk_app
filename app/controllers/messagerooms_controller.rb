class MessageroomsController < ApplicationController
  include SessionsHelper
  include MessageroomsHelper
  before_action :logged_in_user
  
  def create
    @task=Task.find_by(id: params[:task_id])
    if not_created_messageroom?(@task)
       @messageroom=@task.messagerooms.build(owner_id: @task.user_id, guest_id: current_user.id)
       if @messageroom.save
        @task.request_count += 1
        redirect_to task_messageroom_url(@task.id, @messageroom.id)
       else
        flash[:danger] = "メッセージルームの作成に失敗しました。"
        redirect_to tasks_url
       end
    else
      task_messageroom_url(@task.messagerooms.find_by(owner_id: @task.user_id, guest_id: current_user.id))
    end
  end

  # def destroy
  #   @task = Task.find_by(task_id: params[:task_id])
  #   if @task.is_solved?
  #     @task.messagerooms.each do |room|
  #       room.destroy
  #     end
  #   end
  #   flash[:success] = "頼みごとが解決しました。"
  #   redirect_to user_url(@task.user)
  # end

  def show
    
  end
end
