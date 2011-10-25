class Friendship < ActiveRecord::Base
  belongs_to :user  
  belongs_to :friend, :class_name => 'User'
  after_create do |f|
      if !Friendship.find(:first, :conditions => { :friend_id => f.user_id })
        Friendship.create!(:user_id => f.friend_id, :friend_id => f.user_id)
      end
    end
    after_destroy do |f|
      reciprocal = Friendship.find(:first, :conditions => { :friend_id => f.user_id })
      reciprocal.destroy unless reciprocal.nil?
    end
    
	def self.create_both(user, friend)
    	unless user == friend or Friendship.exists?(user, friend)
        	create(:user => user, :friend => friend)
        	create(:user => friend, :friend => user)
    	end
  	end
  
end
