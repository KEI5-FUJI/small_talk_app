class MessagesController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user
  before_action :is_guest_or_owner

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

    def is_guest_or_owner
      @messageroom = Messageroom.find(params[:messageroom_id])
      owner = User.find(@messageroom.owner_id)
      guest = User.find(@messageroom.guest_id)
      unless current_user == owner || current_user == guest
        redirect_to tasks_path
      end
    end

end
