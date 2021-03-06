class UsersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :authenticate_user!
  before_filter :authenticate_admin, :except => [:publicprofile, :friends]
  
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
  
  def friends
    @users = current_user.friends.where("LOWER(display_name) LIKE ?", "%#{params[:q].downcase}%")
    respond_to do |format|
      format.html
      format.json { render :json => @users.map { |val| val.to_simple_array} }
    end
  end
  
  def logout
    sign_out current_user
    redirect_to root_url
  end
  
private
  
  def find_user
    @user ||= User.find(params[:user_id])
  end
    
end
