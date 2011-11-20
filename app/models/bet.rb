class Bet < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, :dependent => :destroy
  has_many :wagers, :order => "created_at DESC", :dependent => :destroy
  has_many :comments, :as => :commentable, :order => "created_at DESC", :dependent => :destroy
  has_one :topic
  belongs_to :bet_category
  belongs_to :challengee, :class_name => "User", :foreign_key => "challengee_id"
  attr_accessible :title, :description, :visibility, :bet_category_id, :end_date, :wager_amount, :verify_description, :verified, :confirmed, :user_id, :wagers_count, :status, :challengee, :challengee_token
  attr_reader :challengee_token
  validates_numericality_of :wager_amount, 
             :less_than_or_equal_to => 20, 
             :greater_than_or_equal_to => 1, 
             :only_integer => true
  validates :title, :presence => true, :length => { :minimum => 2, :maximum => 80 }
  validates :description, :presence => true, :length => { :minimum => 20, :maximum => 500 }
  validates :verify_description, :presence => true, :length => { :minimum => 20, :maximum => 500 }
  validates :end_date, :presence => true, :valid_date => true, :on => :create
  validate :wager_amount_is_valid_amount
  validate :private_bet_has_chanllengee
  scope :standard, :order => "verified ASC, end_date DESC", :conditions => ["confirmed = ?", true] 
  scope :public_bets, :order => "verified ASC", :conditions => ["confirmed = ? AND visibility = ?", true, "Public"]  
  scope :unconfirmed, :order => "created_at DESC", :conditions => ["confirmed = ? AND visibility = ?", false, "Public"]  
  scope :end_date_reached, :order => "end_date DESC", :conditions => ["status = ? and end_date < ?", "Undecided", Time.now]   
    # scope :all_for_friends, lambda{ |friends|
    #       {
    #         :joins      => {:users, :friendships},
    #         :conditions => {:friendships => {:group_id => friends.id},
    #         :select     => "DISTINCT `comments`.*"
    #       }
    #     }
  self.per_page = 10
  # search_methods :end_date_reached
  scope :private_bets, lambda{ |user|
        {
          :joins => "JOIN (SELECT friend_id AS user_id 
                                    FROM   friendships 
                                    WHERE  user_id = #{user.id} UNION SELECT #{user.id}
                              ) AS friends ON bets.user_id = friends.user_id",
          :conditions => ["visibility = ?", "Private"]                       
        }
      }
      
  scope :default, lambda{ |user|
        {
          :joins => "JOIN (SELECT friend_id AS user_id 
                                    FROM   friendships 
                                    WHERE  user_id = #{user.id} UNION SELECT #{user.id}
                              ) AS friends ON bets.user_id = friends.user_id WHERE confirmed = 't' AND visibility = 'Private' UNION SELECT bets.* FROM bets",
          :conditions => ["confirmed = ? AND visibility = ?", true, "Public"]                 
        }
      }    
    
  def end_date_is_valid
      if ((DateTime.parse(end_date.to_s) rescue ArgumentError) == ArgumentError)
        errors.add(:end_date, 'must be a valid datetime') 
      else  
        errors.add(:end_date, "must be over 24 hours from now") if end_date < 24.hours.from_now
      end
  end
  
  def wager_amount_is_valid_amount
    errors.add("errors", "You need at least 1 credit to create a bet. Please purchase more credits") if (wager_amount > user.wallet.credits )
  end
  
  def private_bet_has_chanllengee
    errors.add("errors", "You need add a challengee") if (visibility == "Private" && challengee.nil?)
  end
  
  def challengee_token=(ids)
      self.challengee_id = ids
  end
    
  def set_defaults(currentuser)
    self.end_date = 3.days.from_now
    self.wager_amount = 1
    self.user  = currentuser
  end
  
  def to_param
    "#{id}-#{title.parameterize}"
  end  
  
  def wagers_cached
    @wagers_cached ||= Rails.cache.fetch("bet-#{id}-wagers-results", :expires_in => 1.day) {
      wagers.all 
    }
  end
  
  def total_wagers
    @total_wagers ||= wagers_cached.size  
  end  
    
  def total_value
    @total_value ||= Rails.cache.fetch("bet-#{id}-wagers-value", :expires_in => 1.day) { 
      wagers_cached.sum(&:credits)
    }
  end  
  
  def validity_status
    if self.status == "Undecided" && self.end_date < Time.now
      return "Pending"
    else
      return status
    end
  end 
  
  def winning_wagers
    winners = Array.new
    for wager in self.wagers
      if (wager.against != (self.status == "Won"))
        winners << wager
      end  
    end  
    return winners
  end 
    
  def losing_wagers
    losers = Array.new
    for wager in self.wagers
      if (wager.against == (self.status == "Won"))
        losers << wager
      end  
    end  
    return losers
  end    
  
  def wagers_for
    @wagers_for ||= Rails.cache.fetch("bet-#{id}-wagers-for", :expires_in => 1.day) {
      wagers.wagers_for.all  
    }
  end
  
  def wagers_against
    @wagers_against ||= Rails.cache.fetch("bet-#{id}-wagers-against", :expires_in => 1.day) {
      wagers.wagers_against.all  
    }
  end
  
  def most_wagers
    @most_wagers ||= Rails.cache.fetch("bet-#{id}-most-wagers", :expires_in => 1.day) {
        Wager.find(
           :all, 
           :select => 'count(*) as amount, user_id', 
           :group => 'user_id', 
           :conditions => ['bet_id = ?', id ], 
           :limit => 1).first 
    }
  end
  
  def wager_by_user(user)
    @userwagers ||= wagers.where(:user_id => user).first 
  end
  
  def total_bonus_credits
    bonuses = Bonus.all
    bonuscredits = 0
    bonuses.each do |bonus|
      case bonus.bonustype
        when "Ratio" then
          ratio = (wagers.wagers_for.size / wagers.wagers_against.size) rescue 0
          if ratio >= bonus.target
            bonuscredits += bonus.credits
          end
        when "WagersTotal" then
          if wagers.size >= bonus.target
            bonuscredits += bonus.credits
          end
        else
      end
    end
    return bonuscredits
  end
  
  def bonus_credits(beneficiary)
    bonuses = Bonus.where(:beneficiary => beneficiary)
    bonuscredits = 0
    bonuses.each do |bonus|
      case bonus.bonustype
        when "Ratio" then
          ratio = (wagers.wagers_for.size / wagers.wagers_against.size) rescue 0
          if ratio >= bonus.target
            bonuscredits += bonus.credits
          end
        when "WagersTotal" then
          if wagers.size >= bonus.target
            bonuscredits += bonus.credits
          end
        else
      end
    end
    return bonuscredits
  end
  
  def assign_winnings(result)
    totalamount = self.wagers.sum(:credits).to_i
    totalamount += bonus_credits("Winners")
    if (result)
      creatorpoints = bonus_credits("Bet Creator")
      if creatorpoints > 0
        user.notifications.create!(:title => "You were awarded #{creatorpoints} bonus credits", :message => "You were awarded #{creatorpoints} bonus credits for the following bet - #{title}")
        user.wallet.add_points(creatorpoints)
      end
      indv_amount = totalamount / self.wagers.wagers_for.size 
    else
      indv_amount = totalamount /  self.wagers.wagers_against.size if result == false 
    end  
    for wager in self.wagers
      if (wager.against != result)
        wager.user.wallet.add_points(1)   
        wager.user.wallet.add_credits(indv_amount)
        wager.user.wallet.transactions.create!(:description => "Won #{indv_amount.to_s} credits")
      else (wager.against == result)  
        wager.user.wallet.add_points(-1) 
      end
      ActionController::Base.new.expire_fragment('mystats-' + wager.user.id.to_s)
    end  
    ActionController::Base.new.expire_fragment('bragging')
  end
  
  def add_topic
    topic = Forum.first.topics.build(:title => self.title, :body => (ActionController::Base.helpers.content_tag :blockquote, self.description) + "\n view BETID#{self.id}BETID" )
    topic.user = self.user
    topic.bet = self
    topic.save
  end
    
end