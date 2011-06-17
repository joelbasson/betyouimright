class WalletsController < ApplicationController
  respond_to :html, :xml, :json, :js, :fb
  before_filter :authenticate_user!
  before_filter :get_wallet
  before_filter :get_current_user, :only => [:editname, :cancelname]
  before_filter :check_time_to_credit, :only => [:show]
  
  def show  
    respond_with(@wallet) do |format|
      format.fb { render :layout => false }
    end
  end
  
  def editname
    params[:display_name] = @user.display_name
  end
  
  def updatename
    if !params[:display_name].blank?
      @user = current_user
      @user.update_attribute(:display_name, params[:display_name])
      flash[:notice] = "Successfully update display name"
      render :action => 'cancelname'
    else
      flash[:notice] = "The display name cannot be blank"
      render :action => 'errorname'
    end
  end    
    
  def cancelname
  end    
  
  private
  
  def get_wallet
    @wallet = current_user.wallet
  end  
  
  def get_current_user
    @user = current_user
  end  
  
end
