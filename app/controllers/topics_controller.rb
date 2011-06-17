class TopicsController < ApplicationController  
  layout "forum"
  before_filter :authenticate_user!, :except => [:show, :edit, :update, :destroy]
  before_filter :authenticate_admin_owner, :only => [:edit, :update, :destroy]
  
  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(:per_page => 10, :page => params[:page])
    @topic.hit! if @topic
  end
  
  def new
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.new
  end
  
  def create
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.build(params[:topic])
    @topic.user = current_user
    
    if @topic.save
      flash[:notice] = "Topic was successfully created."
      redirect_to topic_url(@topic)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update   
    if @topic.update_attributes(params[:topic])
      flash[:notice] = "Topic was updated successfully."
      redirect_to topic_url(@topic)
    end
  end

  def destroy    
    if @topic.destroy
      flash[:notice] = "Topic was deleted successfully."
      redirect_to forum_url(@topic.forum)
    end
  end
  
  private
  
  def authenticate_admin_owner
    authenticate_user!
    @topic = Topic.find(params[:id])
    unless current_user.admin? || @topic.user == current_user
      redirect_to :back, :notice => "You are not authorized for that"
    end
  end
  
end
