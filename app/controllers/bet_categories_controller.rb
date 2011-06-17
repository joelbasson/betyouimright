class BetCategoriesController < ApplicationController
  respond_to :html, :xml, :json, :js, :fb
  before_filter :authenticate_admin, :except => [:index, :show]
  
  def index
    @grouped = {}
    BetCategory.all.each do |bet_category|
      letter = bet_category.name.slice(0,1).upcase
      @grouped[letter] ||= []
      @grouped[letter] << bet_category
    end
    respond_with(@grouped) do |format|
      format.fb { render :layout => false }
    end
  end

  def show
    @bet_category = BetCategory.find(params[:id])
    if !params[:search]
      params["search"] = {"meta_sort" => "wagers_count.desc"}
    end  
    @search = Bet.where(:bet_category_id => @bet_category).search(params[:search])
    @bets = @search.paginate(:per_page => Bet.per_page, :page => params[:page])
    @searchtitle = !params['search']['title_or_description_or_user_display_name_contains'].blank? ? @bet_category.name + " - #{params['search']['title_or_description_or_user_display_name_contains']}" : @bet_category.name
    respond_with(@bets) do |format|
      format.fb { render :layout => false }
    end
  end

  def new
    @bet_category = BetCategory.new
  end

  def create
    @bet_category = BetCategory.new(params[:bet_category])
    if @bet_category.save
      expire_fragment('bet-categories')
      expire_fragment('top-bet-categories')
      expire_fragment('fb-bet-categories')
      expire_fragment('fb-top-bet-categories')
      redirect_to bet_categories_url, :notice => "Successfully created bet category."
    else
      render :action => 'new'
    end
  end

  def edit
    @bet_category = BetCategory.find(params[:id])
  end

  def update
    @bet_category = BetCategory.find(params[:id])
    if @bet_category.update_attributes(params[:bet_category])
      expire_fragment('bet-categories')
      expire_fragment('top-bet-categories')
      redirect_to bet_categories_url, :notice  => "Successfully updated bet category."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @bet_category = BetCategory.find(params[:id])
    @bet_category.destroy
    redirect_to bet_categories_url, :notice => "Successfully destroyed bet category."
  end
end
