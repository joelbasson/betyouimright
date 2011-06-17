class ForumsController < ApplicationController    
  layout "forum"
  before_filter :authenticate_admin, :except => [:show]
  
  def show
    @forum = Forum.find(params[:id] ? params[:id] : 1)
    @topics = @forum.topics.paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    @forum = Forum.new
  end
  
  def create
    @forum = Forum.new(params[:forum])
    
    if @forum.save
      flash[:notice] = "Forum was successfully created."
      redirect_to forums_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @forum = Forum.find(params[:id])
  end
  
  def update
    @forum = Forum.find(params[:id])
    
    if @forum.update_attributes(params[:forum])
      flash[:notice] = "Forum was updated successfully."
      redirect_to forum_url(@forum)
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    
    if @forum.destroy
      flash[:notice] = "Category was deleted."
      redirect_to forums_url
    end
  end
end