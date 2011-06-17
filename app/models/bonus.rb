class Bonus < ActiveRecord::Base
  attr_accessible :name, :short_description, :description, :rule, :rule_description, :activation, :target, :credits, :beneficiary, :bonustype
  
  def get_status(bet)
    case bonustype
      when "Ratio" then
        ratio = (bet.wagers.wagers_for.size / bet.wagers.wagers_against.size) rescue 0
        if ratio >= target
          "Activated"
        else
          "#{ratio} of #{target} completed"
        end
      when "WagersTotal" then
        if bet.wagers.size >= target
          "Activated"
        else
          "#{bet.wagers.size} of #{target} completed"
        end
      else
        ""
    end
  end
  
  def self.bonus_types
    ["Ratio", "WagersTotal"]
  end
  
  def self.activation_types
    ["Trigger", "Completion"]
  end
  
  def self.beneficiary_types
    ["Winners", "Bet Creator"]
  end
  
end
