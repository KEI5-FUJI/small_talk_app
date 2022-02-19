class MessageroomsController < ApplicationController
  include SessionsHelper
  include MessageroomsHelper
  before_action :logged_in_user
  before_action :set_task
  before_action :is_task_messageroom_list_current_user, only: [:index]
  before_action :is_guest_or_owner, only: [:show]
  before_action :is_owner, only: [:destroy]
  before_action :is_follower_of_owner, only: [:create]
  
  def create
    if not_created_messageroom?(@task)
       @messageroom=@task.messagerooms.build(owner_id: @task.user_id, guest_id: current_user.id)
       if @messageroom.save
        redirect_to task_messageroom_url(@task.id, @messageroom.id)
       else
        flash[:danger] = "メッセージルームの作成に失敗しました。"
        redirect_back_or tasks_url
       end
    else
      redirect_to task_messageroom_url(@task.messagerooms.find_by(owner_id: @task.user_id, guest_id: current_user.id))
    end
  end

  def destroy
    @task.toggle(:is_solved?)
    if @task.is_solved?
      @task.messagerooms.each do |room|
        room.destroy
      end
    end
    @task.destroy
    flash[:success] = "頼みごとが解決しました。"
    redirect_to user_url(@task.user)
  end

  def show
    if @messageroom = @task.messagerooms.find(params[:id])
      @room_messages = @messageroom.messages
      @message = @messageroom.messages.build
    else 
      redirect_to tasks_index_url
    end
  end

  def index
    @messagerooms = @task.messagerooms
  end

  private 
    def set_task
      @task = Task.find(params[:task_id])
    end

    def is_task_messageroom_list_current_user
      unless current_user == Task.find(params[:task_id]).user
        redirect_back_or tasks_url
      end
    end

    def is_guest_or_owner
      @messageroom = Messageroom.find(params[:id])
      owner = User.find(@messageroom.owner_id)
      guest = User.find(@messageroom.guest_id)
      unless current_user == owner || current_user == guest
        redirect_back_or tasks_url
      end
    end

    def is_owner
      @messageroom = Messageroom.find(params[:id])
      owner = User.find(@messageroom.owner_id)
      unless current_user == owner
        redirect_back_or tasks_url
      end
    end

    def is_follower_of_owner
      owner = Task.find(params[:task_id]).user
      unless owner.followers.include?(current_user)
        redirect_back_or tasks_url
      end
    end
end
