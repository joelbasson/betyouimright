class CashoutsController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :find_purchase, :only => [:destroy]
  before_filter :authenticate_user!
  before_filter :is_allowed

  def index
    if !params[:search]
      params["search"] = {"meta_sort" => "id.desc"}
    end
    @search = Cashout.search(params[:search])
    @cashouts = @search.paginate(:per_page => 10, :page => params[:page])
  end
  
  def new
    @cashout = Cashout.new(:amount => 200)
  end
  
  def create
      @cashout = Cashout.new(params[:cashout])
      @cashout.assign_credit_value if @cashout.amount
      @cashout.user = current_user
      @cashout.wallet = current_user.wallet
      if @cashout.save
        @cashout.wallet.update_attribute(:credits, @wallet.credits - @cashout.amount)  
        @cashout.wallet.transactions.create!(:description => "Initiated cashout #{@cashout.amount.to_s} credits.")
        @cashout.pay
        redirect_to root_url, :notice => "Initiated Cashout ID #{@cashout.id} for #{@cashout.amount.to_s} credits."
        # redirect_to @cashout.paypal_url(payment_notifications_url,payment_notifications_url)  
      else
        flash[:notice] = @cashout.errors.full_messages.to_sentence
        render :action => 'new'
    end
  end
  
  def destroy
    @cashout = Cashout.find(params[:id])
    @cashout.destroy
    redirect_to cashouts_url, :notice => "Successfully destroyed cashout."
  end
  
  private
  
  def is_allowed
    if APP_CONFIG["allow_cashouts"] != true
      redirect_to root_url, :notice => "You are not authorized for that"
    end  
  end
  
end
