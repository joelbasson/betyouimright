module CommentHelper
  
  def is_owner_or_admin(comment)
    if user_signed_in?
      if current_user.admin || comment.user == current_user
        return true
      end
    end
    return false
  end
end
