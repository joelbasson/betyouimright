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
  scope :by_scores, joins(:wallet) & Wallet.by_scores
  scope :top10, by_scores.limit(10)
    
  def apply_omniauth(omniauth)  
    self.email = omniauth['user_info']['email'] if omniauth['user_info']['email']
    if omniauth['user_info']['nickname'] && !omniauth['user_info']['nickname'].blank? 
      self.display_name = omniauth['user_info']['nickname']
    else
      self.display_name = omniauth['user_info']['name']
    end
    
    self.profile = omniauth['user_info']['image']
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])  
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
