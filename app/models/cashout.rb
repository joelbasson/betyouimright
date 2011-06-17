class Cashout < ActiveRecord::Base
  extend HerokuDjAutoScale 
  attr_accessible :wallet_id, :amount, :paypal_email, :completed_at, :return_message
  belongs_to :user
  belongs_to :wallet
  has_one :payment_notification
  validates_presence_of :amount
  validates :paypal_email,   
              :presence => true,     
              :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  validates_numericality_of :amount, :only_integer => true, :message => "can only be a whole number."
  validates_numericality_of :amount, :greater_than_or_equal_to => 200, :message => "must be 200 or above"
  validate do |cashout|
      cashout.errors.add(:amount, "is more than available credits") if cashout.amount > cashout.wallet.credits
      cashout.errors.add(:amount, "must be in multiples of 50") if cashout.amount && (cashout.amount / 50) % 1 != 0
  end
  
  def assign_credit_value
    self.value = self.amount * APP_CONFIG["sell_credit_value"].to_d
  end  
  
  def currency
    APP_CONFIG["default_currency_code"]
  end  
  
  def status
    if self.completed_at 
       return "completed"
    elsif self.return_message   
       return "failed"
    else
      return "waiting"
    end    
  end  
  
  def pay
    response = STANDARD_GATEWAY.transfer(self.value * 10, "test3_1299880615_per@betyoulose.com", :subject => "Payment from Seller", :note => "Cashout from" + APP_CONFIG["application_name"])
    if response.success?
      self.update_attributes(:completed_at => Time.now, :return_message => response.message)
      self.wallet.transactions.create!(:description => "Cashout ID #{id} for #{amount} credits successful")
    else
      self.wallet.update_attribute(:credits,  self.wallet.credits + self.amount)
      self.update_attribute(:return_message,  response.message)
      self.wallet.transactions.create!(:description => "Cashout ID #{id} Failed: " + response.message)
    end
  end
  handle_asynchronously :pay, :run_at => Proc.new { 5.minutes.from_now }
  
end
