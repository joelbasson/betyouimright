class Wager < ActiveRecord::Base
  belongs_to :bet, :counter_cache => true
  belongs_to :user
  validate :wager_amount_is_valid_amount
  validate :bet_is_current
  scope :wagers_for, :conditions => ["against = ?", false]  
  scope :wagers_against, :conditions => ["against = ?", true]  
  scope :bet_completed, joins(:bet).where("bets.status != ?", "Undecided")
  after_create :create_transactions
  self.per_page = 10
  
  def wager_amount_is_valid_amount
    errors.add_to_base("You need at least 1 credit to wager. Please purchase more credits") if (credits > user.wallet.credits )
  end
  
  def bet_is_current
    errors.add_to_base("This bet has reached its end date") if (bet.end_date < Time.now )
  end
  
  def create_transactions
    self.user.wallet.update_attribute(:credits, self.user.wallet.credits - self.credits)
    self.user.wallet.transactions.create!(:description => "Bet #{self.credits.to_s} credits", :bet_id => self.bet)
  end
  
  def in_words
    if against
      "Bet that this bet is a Fail!"
    else
      "Bets that this bet is right!"
    end   
  end
  
   
end
