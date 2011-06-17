class UsersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :authenticate_user!
  before_filter :authenticate_admin, :except => [:publicprofile]
  
  def index
    @search = User.search(params[:search])
    @users = @search.paginate(:per_page => 2, :page => params[:page])
  end
  
  def publicprofile
    @user = User.find(params[:user_id])
  end
  
  def toggleadmin
    @user = User.find(params[:id])
    @user.admin = !@user.admin 
    @user.save
    respond_with(@user) do |format|
      format.html { redirect_to :action => "index" }
    end
  end  
    
end
