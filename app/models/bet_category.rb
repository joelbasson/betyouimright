class BetCategory < ActiveRecord::Base
  attr_accessible :name
  has_one :bet
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
end
