module NotificationsHelper
  
  def create_notifications
    messages = ""
    if user_signed_in?
      unless current_user.notifications.top5.empty?
        messages += "<div id='notifications'><div id='notifications-button'><div class='down-arrow'></div><div class='notifications-button-text'>You have #{pluralize(current_user.notifications.top5.count, 'unread notification')}</div></div><div id='notifications-wrapper'>"
        current_user.notifications.top5.each do |notification|
          messagebody = truncate(notification.title, :length =>55) + "<div class='close-link'>#{link_to 'X', '/javascripts/close_link.js?notification='+ notification.id.to_s, :title => 'Remove', :remote => true}</div>" + (content_tag :div, raw(notification.message), :id => "notification-#{notification.id}-message", :class => "notification-message")
          messages += content_tag :div, raw(messagebody), :id => "notification-#{notification.id}", :class => "notification", "data-tooltip" => notification.message
        end
        messages += "</div></div>"
      end
    end
    return raw(messages)
  end
  
end
