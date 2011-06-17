class PaymentNotification < ActiveRecord::Base
  belongs_to :purchase
  serialize :params
  validates_uniqueness_of :purchase_id
  after_create :mark_purchase_as_purchased

  private

  def mark_purchase_as_purchased
    if status == "Completed"
      purchase.update_attribute(:purchased_at, Time.now)
      purchase.wallet.update_attribute(:credits, purchase.wallet.credits + purchase.amount)
      purchase.wallet.transactions.create!(:description => "Successfully purchased #{purchase.amount.to_s} credits.")
    end
  end
  
end
