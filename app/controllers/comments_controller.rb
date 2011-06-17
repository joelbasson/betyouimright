class CommentsController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :authenticate_user!
  before_filter :authenticate_owner_admin, :only => [:edit, :update, :destroy]

  def new
    @parent_comment = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @comment = @parent_comment.comments.build
  end

  def create
    @comment = @parent.comments.build(params[:comment])
    @comment.user = current_user
    @comment.save_spam
    
    if @comment.save
      for i in 1..(@comment.bet.comments.size / Comment.per_page).ceil
         expire_fragment("bet-#{@comment.bet.id.to_s}-comments-page-#{i}"); 
      end
      # Mailer.delay.new_bet(@comment)
      flash[:notice] = 'Thank you for your comment!'
      respond_with(@comment) do |format|
        format.html { redirect_to bet_path(@comment.bet) }
      end
    else
      respond_with(@comment) do |format|
        @model = @comment
        format.js   { render :template => 'shared/validation_error.js.erb'}
      end
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment was updated successfully."
      respond_with(@comment)
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    
    if @comment.destroy
      flash[:notice] = "Comment was deleted."
      respond_with(@comment)
    end
  end
  
  def cancel
    @comment = Comment.find(params[:comment_id])
    @parent_comment = Comment.find_by_id(params[:parent_comment]) if params[:parent_comment]
  end  
  
  def cancel_new
    @parent_comment = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    render 'cancel'
  end

  protected

  def authenticate_owner_admin
    @comment = Comment.find(params[:id])
    if !current_user.admin? || @comment.user != current_user
      flash[:notice] = "You are not authorized for that"
      render 'shared/show_notice'
    end
  end
end
