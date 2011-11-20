class WagerSweeper < ActionController::Caching::Sweeper
  observe Wager 
  
  def after_create(wager)
    expire_cache_for(wager)
  end
 
  def after_update(wager)
    expire_cache_for(wager)
  end
 
  def after_destroy(wager)
    expire_cache_for(wager)
  end
 
  private
  def expire_cache_for(wager)
    expire_fragment("bet-small-#{wager.bet.id}")
    expire_fragment("bet-#{wager.bet.id}")
    expire_fragment("bet-#{wager.bet.id}")
    expire_fragment("bet-#{wager.bet.id}-wagers")
    expire_fragment("bet-#{wager.bet.id}-wagers-results")
    expire_fragment("bet-#{wager.bet.id}-wagers-value")
    expire_fragment("bet-#{wager.bet.id}-wagers-for")
    expire_fragment("bet-#{wager.bet.id}-wagers-against")
    expire_fragment("bet-#{wager.bet.id}-bonus-panel")
  end
end