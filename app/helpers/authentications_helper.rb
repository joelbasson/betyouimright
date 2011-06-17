module AuthenticationsHelper
  
  def create_url
    raw("http://www.facebook.com/connect/uiserver.php?app_id=104465769636132&method=permissions.request&display=page&next=#{u "http://apps.facebook.com/betyouimright/auth/facebook/callback"}&type=web_server&canvas=1&perms=email%2Coffline_access")
  end  
end
