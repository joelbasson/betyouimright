class JavascriptsController < ApplicationController
  
  def facebook
  end
  
  def dynamic_fb_popup
    @bet = Bet.find(params[:bet_id])
  end
  
  def canvas_fb_popup
    @bet = Bet.find(params[:bet_id])
  end
  
  def facebook_friends
  end
  
  def cache_fb_friends
    session[:facebook_friends_list] = params[:friendsList]
    render :nothing => true
  end
  
  def cache_fb_friends_html
    session[:facebook_friends_html] = params[:friendsHtml]
    render :nothing => true
  end
  
  def get_country_code
    if APP_CONFIG["show_country_redirect"] == true
      if !session[:country] 
        country = {
                    :code => Net::HTTP.get(URI.parse("http://ws.geonames.org/countryCode?lat=" + params["lat"] + "&lng=" + params["lng"])).to_s.strip,
                    :shown => false
        }
        session[:country] = country
      end
    else
      render :nothing => true
    end
  end
  
  def close_link
    @notification = Notification.find_by_id(params["notification"])
    if @notification
      @notification.update_attribute("closed", true)
    else
      render :nothing => true
    end
  end
  
  def expire_fb_comments
    expire_fragment("fbcomments-#{params['bet']}"); 
    render :nothing => true
  end
  
  def clear_session
    session[:facebook_canvas] = nil
    session['fb_auth'] = nil
    session['fb_token'] = nil
    session['fb_error'] = nil
    session['facebook_friends_html'] = nil
    session['facebook_friends_list'] = nil
    render :nothing => true
  end  
  
end
