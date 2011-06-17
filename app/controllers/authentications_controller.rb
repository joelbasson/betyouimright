class AuthenticationsController < ApplicationController  
  
  def index   
    @authentications = current_user.authentications if current_user  
  end 
  
  def show
    redirect_to root_url  
  end  
    
  def create  
    # render :text => request.env["omniauth.auth"].to_yaml  
    omniauth = request.env["omniauth.auth"]  
    if omniauth['provider'] == "facebook"
      # session['fb_auth'] = request.env['omniauth.auth'] 
      # session['fb_token'] = session['fb_auth']['credentials']['token'] 
      # session['fb_error'] = nil
    end
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])  
    if authentication  
      flash[:notice] = "Signed in successfully."  
      sign_in(:user, authentication.user) 
      redirect_to request.env['omniauth.origin'] || root_url
    elsif current_user  
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])  
      user.save
      flash[:notice] = "Signed in successfully - Added #{omniauth['provider']} access to existing account."
      redirect_to request.env['omniauth.origin'] || root_url  
    else  
      user = User.find_by_email(omniauth['user_info']['email'])
      if user
        user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])  
        user.save
        flash[:notice] = "Signed in successfully - Added #{omniauth['provider']} access to existing account."  
        sign_in(:user, user) 
        redirect_to request.env['omniauth.origin'] || root_url
      else
        user = User.new  
        user.apply_omniauth(omniauth)  
        if user.save   
          flash[:notice] = "Registered successfully via #{omniauth['provider']}."  
          sign_in(:user, user) 
          redirect_to request.env['omniauth.origin'] || root_url
        else  
          flash[:alert] = "Could not register your user. Try registering traditonally" 
          redirect_to new_registration_path('user') 
        end 
      end
    end
  end  
    
  def destroy  
    @authentication = current_user.authentications.find(params[:id])  
    @authentication.destroy  
    flash[:notice] = "Successfully destroyed authentication."  
    redirect_to authentications_url  
  end  
  
  def setup
    if is_facebook?
      request.env['omniauth.strategy'].options = {:iframe => true, :canvas => true} 
    else
      request.env['omniauth.strategy'].options = {:iframe => true, :canvas => false} 
    end
    render :text => "Setup complete.", :status => 404
  end
    
  def failure
    flash[:alert] = "Could not register your user. Error was '#{params['message']}'" 
    redirect_to new_session_path('user') 
  end    
  
end