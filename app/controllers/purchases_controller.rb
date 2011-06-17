class PurchasesController < ApplicationController
  respond_to :html, :xml, :json, :js
  before_filter :find_purchase, :only => [:show, :destroy]
  before_filter :authenticate_admin, :except => [:new, :create]
  before_filter :authenticate_user!, :only => [:new, :create]
  
  def index
    if !params[:search]
      params["search"] = {"meta_sort" => "id.desc"}
    end
    @search = Purchase.search(params[:search])
    @purchases = @search.paginate(:per_page => 10, :page => params[:page])
  end

  def show
  end
  
  def new
    @purchase = Purchase.new(:amount => 2)
  end
  
  def create
      @purchase = Purchase.new(params[:purchase])
      @purchase.assign_credit_value if @purchase.amount
      @purchase.user = current_user
      @purchase.wallet = current_user.wallet
      if @purchase.save
        @purchase.wallet.transactions.create!(:description => "Attempted to purchase #{@purchase.amount.to_s} credits.")
        if session[:facebook_canvas]
          @js = "top.location.href = '#{@purchase.paypal_url('http://apps.facebook.com/betyouimright/',payment_notifications_url)}';"
          render :inline => "<%= javascript_tag(@js) %>" 
        else
          redirect_to @purchase.paypal_url(payment_notifications_url,payment_notifications_url)  
        end
      else
        render :action => 'new'
    end
  end

  def destroy
    @purchase.destroy
    redirect_to purchases_url, :notice => "Successfully destroyed purchase."
  end
  
  def payment_info
    purchase = Purchase.find(params[:purchase_id])
    @payment_notification = purchase.payment_notification
  end  
  
  private
  
  def find_purchase
    @purchase = Purchase.find(params[:id])
  end  
end
