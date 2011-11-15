class ApplicationController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  before_filter :check_next_page
  before_filter :prepare_for_facebook
  
    def after_sign_in_path_for(resource)
      case resource
        when :user, User 
          if current_user.wallet.nil?
            wallet = current_user.build_wallet
            wallet.credits = 0
            wallet.save
            current_user.save
          end
          if current_user.display_name.blank?
            current_user.display_name = "Please Change me!"
            current_user.save
            wallet_path(current_user.wallet)
          else
           (session[:"user.return_to"].nil?) ? super : session[:"user.return_to"].to_s
          end
      else
        super
      end
   end
    
    private
    
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
    
    def check_next_page
      if params[:next]
        session[:"user.return_to"] = params[:next]
      end
    end
    
    def authenticate_admin
      authenticate_user!
      unless current_user.admin?
        redirect_to :back, :notice => "You are not authorized for that"
      end  
    end  
    
    def base64_url_decode(str)
     encoded_str = str.gsub('-','+').gsub('_','/')
     encoded_str += '=' while !(encoded_str.size % 4).zero?
     Base64.decode64(encoded_str)
    end

    def decode_data(str)
     encoded_sig, payload = str.split('.')
     data = ActiveSupport::JSON.decode base64_url_decode(payload)
    end
    
    def check_time_to_credit
      if current_user
        if !current_user.wallet.nil? && current_user.wallet.pointtime < Time.now
          current_user.wallet.pointtime = 1.week.from_now
          current_user.wallet.credits += 2
          current_user.wallet.save
          flash[:notice] = "You earned another 2 credits"
        end
      end  
    end
    
    def is_facebook?
      if params[:use_facebook]
        if params[:use_facebook] == 'true'
          session[:facebook_canvas] = true 
        else
          session[:facebook_canvas] = nil 
        end  
      elsif params[:signed_request]
          session[:facebook_canvas] = true
      end
      if session[:facebook_canvas]
        true
      else
        false
      end
    end
    helper_method :is_facebook?

    def prepare_for_facebook
      request.format = :fb if request.format != :js && request.format != :json && is_facebook?
    end
    
    def check_facebook_canvas
      signed_request = params[:signed_request]
      if signed_request
        session[:facebook_canvas] = true
        if current_user
        else 
          @signed_request = decode_data(signed_request) 
          authentication = Authentication.find_by_provider_and_uid("facebook", @signed_request["user_id"])  
          if authentication
            flash[:notice] = "Welcome back #{authentication.user.display_name}"
            sign_in(:user, authentication.user) 
          else
            page = user_omniauth_authorize_path(:facebook_canvas)
            if request.post? && params[:id]
              page += "?origin=" + CGI::escape("/?bet=" + params[:id])
            end 
            redirect_to page
          end
        end
      end
    end
    
end
