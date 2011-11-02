class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :display_name, :profile
  has_many :authentications, :dependent => :destroy 
  belongs_to :wallet, :dependent => :destroy
  has_many :wagers, :dependent => :destroy
  has_many :bets, :dependent => :destroy
  has_many :notifications, :dependent => :destroy, :order => "created_at DESC", :conditions => {:closed => false}
  has_many :topics, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :friendships, :dependent => :destroy
  has_many  :friends, 
            :through => :friendships do
      def bets
        @bets ||=Bet.where("user_id = ? AND visibility = 'Private'", map(&:id)) 
        # find_all_by_user_id(map(&:id)).where("")
      end
  end
  scope :by_scores, lambda {
      joins("join wallets on users.wallet_id = wallets.id").
      where("wallets.score >= ?", 0).
      order("wallets.score DESC")
    }
  scope :top10, by_scores.limit(10)
  
  def friend_bets
      @private_bets ||=Bet.find(:all, 
               :joins => "JOIN (SELECT friend_id AS user_id 
                                FROM   friendships 
                                WHERE  user_id = #{self.id}
                          ) AS friends ON bets.user_id = friends.user_id WHERE bets.visibility = 'Private'")
  end
  
  def private_bets
    @private_bets ||= friend_bets + bets.private
  end
  
  def apply_omniauth(omniauth)  
    self.email = omniauth['user_info']['email']
    self.fbidentifier = omniauth['uid'] 
    if omniauth['user_info']['nickname'] && !omniauth['user_info']['nickname'].blank? 
      self.display_name = omniauth['user_info']['nickname']
    else
      self.display_name = omniauth['user_info']['name']
    end
    self.profile = omniauth['user_info']['image']
    self.fbtoken = omniauth['credentials']['token']
    
    fbuser = FbGraph::User.new('me', :access_token => omniauth['credentials']['token'] )
    fbuser.fetch
    fb_friends_identifiers = fbuser.friends.collect {|f| f.identifier }
    self.fbfriendscollection = fb_friends_identifiers
    self.fbtoken_updated_at = Time.now
    self.friends =  User.find_all_by_fbidentifier(fb_friends_identifiers)
  end
    
  def rank
    User.by_scores.index(self) + 1
  end    
  
  def username
    return display_name
  end
  
  protected
  
  def password_required?  
    (authentications.empty? || !password.blank?) && super  
  end
    
end
