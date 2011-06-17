class SitemapsController < ApplicationController
  respond_to :xml
  caches_page :index

  def index
    @bets = Bet.standard
    @other_routes = ["","about","how","terms", "contact", "privacy", "bragging"]
    @topics = Topic.all
    respond_to do |format|
      format.xml
    end
  end
end