class Comment < ActiveRecord::Base
  include Rakismet::Model
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :user
  rakismet_attrs :author => proc { user.display_name },
                   :author_email => proc { user.email },
                   :content => proc { body }
  scope :not_spam, where(:is_spam => true)
  validates_presence_of :body
  validates_length_of :body, :minimum => 2
  validates_length_of :body, :maximum => 1000
  self.per_page = 5
  # before_save :save_spam
  
  def bet
    return @bet if defined?(@bet)
    @bet = commentable.is_a?(Bet) ? commentable : commentable.bet
  end
  
  def save_spam
    if self.is_spam.nil?
      self.is_spam = self.spam?
    end  
  end  
  
end
