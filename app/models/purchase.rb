class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :wallet
  has_one :payment_notification
  validates_presence_of :amount, :terms
  validates_acceptance_of :terms
  validates_numericality_of :amount, 
             :less_than_or_equal_to => 100, 
             :greater_than_or_equal_to => 1, 
             :only_integer => true
  
  def assign_credit_value
    self.value = self.amount * APP_CONFIG["buy_credit_value"].to_d
  end  
  
  def currency
    APP_CONFIG["default_currency_code"]
  end  
  
  def status
    self.purchased_at ? "completed" : "waiting"
  end  
  
  def paypal_url(return_url, notify_url)
    values = {
      :business => APP_CONFIG["paypal_address"],
      :cmd => '_xclick',
      :upload => 1,
      :return => return_url,
      :invoice => id,
      :notify_url => notify_url,
      :amount => self.value,
      :item_name => self.amount.to_s + " credits",     
      :currency_code => currency
    }
    APP_CONFIG["paypal_url"] + values.to_query
  end
  
end
