class PostsController < ApplicationController    
  layout "forum"
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_admin_owner, :except => [:new, :create]
  
  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    
    if params[:quote]
      quote_post = Post.find(params[:quote])
      if quote_post
        @post.body = (view_context.content_tag :blockquote, quote_post.body) + "\n"
      end
    end
  end
  
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(params[:post])
    @post.forum = @topic.forum
    @post.user = current_user
    
    if @post.save
      flash[:notice] = "Post was successfully created."
      redirect_to topic_path(@post.topic)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was successfully updated."
      redirect_to topic_path(@post.topic)
    end
  end
  
  def destroy
    if @post.topic.posts_count > 1
      if @post.destroy
        flash[:notice] = "Post was successfully destroyed."
        redirect_to topic_path(@post.topic)
      end
    else
      if @post.topic.destroy
        flash[:notice] = "Topic was successfully deleted."
        redirect_to forum_path(@post.forum)
      end
    end
  end
  
  private
  
  def authenticate_admin_owner
    authenticate_user!
    @post = Post.find(params[:id])
    unless current_user.admin? || @post.user == current_user
      redirect_to :back, :notice => "You are not authorized for that"
    end
  end
  
end