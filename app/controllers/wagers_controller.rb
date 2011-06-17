class WagersController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :authenticate_user!
  cache_sweeper :wager_sweeper, :only => [:bet_now]
  
  def my_wagers  
    if params[:user_id]
      return @wagers = User.find(params[:user_id]).wagers.order("id DESC").paginate(:per_page => Wager.per_page, :page => params[:my_wagers_page])
    else
      return @wagers = current_user.wagers.order("id DESC").paginate(:per_page => Wager.per_page, :page => params[:my_wagers_page])
    end
  end

  def bet_now
    @bet = Bet.find(params[:bet_id])
    @wager = @bet.wagers.build(:credits => @bet.wager_amount, :against => params[:against], :user_id => current_user.id)
    if @wager.save 
      flash[:notice] = "You bet #{ActionController::Base.helpers.pluralize(@bet.wager_amount, 'credit')}"
      @wagers = @bet.wagers.paginate(:per_page => 10, :page => params[:page])
      respond_with(@bet) do |format|
        format.html { redirect_to @bet }
      end  
    else
      respond_with(@wager)
    end
  end
    
  private
end
