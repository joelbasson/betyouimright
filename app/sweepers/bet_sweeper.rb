class BetSweeper < ActionController::Caching::Sweeper
  observe Bet # This sweeper is going to keep an eye on the Bet model
 
  # If our sweeper detects that a Bet was created call this
  def after_create(bet)
    expire_cache_for(bet)
  end
 
  # If our sweeper detects that a Bet was updated call this
  def after_update(bet)
    expire_cache_for(bet)
  end
 
  # If our sweeper detects that a Bet was deleted call this
  def after_destroy(bet)
    expire_cache_for(bet)
  end
 
  private
  def expire_cache_for(bet)
    expire_fragment('bet-small-'+ bet.id.to_s)
    expire_fragment('bet-'+ bet.id.to_s)
    expire_fragment('fb-bet-small-'+ bet.id.to_s)
    expire_fragment('fb-bet-'+ bet.id.to_s)
  end
end