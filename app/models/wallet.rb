class Wallet < ActiveRecord::Base
  has_one :user
  has_and_belongs_to_many :awards
  has_many :transactions, :order => "created_at DESC"
  # scope :by_scores, :order => "score DESC", :conditions => ["score >= ? AND display_name != ''", 0]  
  scope :by_scores, :order => "score DESC", :conditions => ["score >= ?", 0]  
  validates_numericality_of :credits
    
  def add_points(points)
    self.score += points
    if points == 1
      award = award_level
      if award && !self.awards.exists?(award)
        self.awards << award      
      end  
    elsif points == -1   
      award = next_award_level
      if award && self.awards.exists?(award)
        self.awards.delete(award)      
      end
    end
    self.save
  end
  
  def award_level
    if self.score > 0 && self.score <= 5
      return Award.find_by_name("Newbie")
    elsif self.score > 5 && self.score <= 20
      return Award.find_by_name("Hero")  
    elsif self.score > 20 && self.score <= 100
      return Award.find_by_name("Legend")
    elsif self.score > 100
      return Award.find_by_name("Master")    
    end  
  end  
  
  def next_award_level
    if self.score <= 0
      return Award.find_by_name("Newbie")
    elsif self.score <= 5
      return Award.find_by_name("Hero")
    elsif self.score <= 20
      return Award.find_by_name("Legend")
    elsif self.score <= 100
      return Award.find_by_name("Master")    
    end  
  end
  
  def add_credits(amount)
    self.credits += amount
    self.save
  end
  
  def time_to_more_credits
    ((pointtime - Time.now) / 60 ).to_i  
  end  
  
  def rel_time_to_more_credits
    100 - ((time_to_more_credits * 100 ) / 10080)
  end
      
end
