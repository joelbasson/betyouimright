class BraggingController < ApplicationController
  respond_to :html, :xml, :json, :js, :fb
  before_filter :check_time_to_credit, :only => [:index]

  def index
    @braggings = User.by_scores.paginate(:per_page => 20, :page => params[:page])
    respond_with(@braggings) do |format|
      format.fb { render :layout => false }
    end
  end
    
end
