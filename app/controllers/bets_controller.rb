class BetsController < ApplicationController
  respond_to :html, :xml, :json, :js, :fb
  before_filter :authenticate_user!, :except => [:index, :show, :feed]
  before_filter :authenticate_admin, :only => [:edit, :update, :destroy]
  before_filter :find_bet, :except => [:index, :new, :create, :my_bets, :feed]
  before_filter :check_time_to_credit, :only => [:index, :show]
  before_filter :check_facebook_canvas, :only => [:index, :show]
  cache_sweeper :bet_sweeper, :only => [:create, :update, :destroy]
  
  def index
    if !params[:search]
      params["search"] = {"meta_sort" => "wagers_count.desc"}
    end  
    if params[:search] && params[:search]["confirmed_is_false"] == "1"
      @search = Bet.search(params[:search])
    else
      @search = Bet.default.search(params[:search])
    end
    @searchtitle = params['search']['title_or_description_or_user_display_name_contains'].to_s
    if params[:bet]
      @fbshowbet = params[:bet]
      request.parameters.delete("bet")
    end
    @bets = @search.paginate(:per_page => Bet.per_page, :page => params[:page])
  end

  def show
    if request.post? && is_facebook?
      redirect_to :action => 'index', :bet => @bet.to_param
    else
      @wagers = @bet.wagers.order("user_id DESC, id DESC")
      @comments = @bet.comments.paginate(:per_page => Comment.per_page, :page => params[:page])
      respond_with(@bet) do |format|
        format.fb { render :layout => false }
      end
    end
  end

  def new
    @bet = Bet.new
    @bet.set_defaults(current_user)
    respond_with(@bet) do |format|
      format.fb { render :layout => false }
    end
  end

  def create
    @bet = Bet.new(params[:bet])
    @bet.confirmed = true if current_user.admin?
    @bet.user = current_user
    @bet.wager_amount = 1
    if @bet.save
      @bet.wagers.create(:credits => @bet.wager_amount, :against => false, :user_id => @bet.user.id)
      @bet.user.wallet.update_attribute(:credits, @bet.user.wallet.credits - @bet.wager_amount)
      @bet.user.wallet.transactions.create!(:description => "Created Bet for #{@bet.wager_amount.to_s} credits.", :bet_id => @bet)
      @bet.add_topic
      Mailer.delay.new_bet(@bet)
      flash[:notice] = "Successfully created bet."
      respond_with(@bet)
    else
      respond_with(@bet) do |format|
        format.html { render :action => 'new' }
        @model = @bet
        format.js   { render :template => 'shared/validation_error.js.erb'}
      end
    end  
  end

  def edit
  end

  def update
    old_status = @bet.status
    @bet.verified = true if params[:bet][:status] != 'Undecided'
    @bet.attributes = params[:bet] 
    @bet.save(:validate => false)
    if @bet.status != old_status && @bet.status != 'Undecided' && @bet.verified
       @bet.assign_winnings(@bet.status == "Won")
    end   
    flash[:notice] = "Successfully updated bet."
    respond_with(@bet)
  end

  def destroy
    @bet.destroy
    respond_with(@bet, :notice => "Successfully destroyed bet.")
  end
  
  def my_bets  
    if params[:user_id]
      return @bets = User.find(params[:user_id]).bets.order("id DESC").paginate(:per_page => Bet.per_page, :page => params[:page]) 
    else
      return @bets = current_user.bets.order("id DESC").paginate(:per_page => Bet.per_page, :page => params[:page])
    end  
  end
  
  def feed
    @bets = Bet.standard.order("created_at ASC").paginate(:per_page => Bet.per_page, :page => params[:page])

    respond_to do |format|
      format.atom
    end
  end
  
  private 
  
  def find_bet
    @bet = Bet.find(params[:id])
  end  
  
end
