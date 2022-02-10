module MessageroomsHelper
  def not_created_messageroom?(task)
    task.messagerooms.find_by(owner_id: task.id, guest_id: current_user.id).nil?
  end

  def messageroom_exist?(task)
    task.messagerooms.where(owner_id: task.user, guest_id: current_user.id).any?
  end
end
