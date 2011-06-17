class Notification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :message, :user_id, :viewed, :closed
  scope :default, :order => "created_at DESC", :conditions => ["closed = ?", false]
  scope :top5, default.limit(5)  
end
