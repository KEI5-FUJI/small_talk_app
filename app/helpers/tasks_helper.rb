module TasksHelper
  def is_current_user_task?(task)
     current_user == task.user
  end
end
