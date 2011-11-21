class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def facebookcanvas
      @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        puts "JOEL 1 => " + APP_CONFIG['canvas_url'] + "BASSON"
        sign_in @user, :event => :authentication

        redirect_to APP_CONFIG['canvas_url']
      else
        session["devise.facebook_data"] = env["omniauth.auth"]
        puts "JOEL 2 => " + APP_CONFIG['canvas_url'] + "BASSON"
        redirect_to APP_CONFIG['canvas_url']
      end
      
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
end