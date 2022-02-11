class MessagesController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    @messageroom = @task.messagerooms.find(params[:messageroom_id])
    @message = @messageroom.messages.build(message_params)
    @message.user_id = current_user.id
    if @message.save
      redirect_to task_messageroom_url(task_id: @task.id, id: @messageroom.id)
    else
      render 'messagerooms/show'
    end
  end

  private 
    def message_params
      params.require(:message).permit(:message)
    end
end
