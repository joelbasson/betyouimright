class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  
  def create
    @payment_notification = PaymentNotification.new(:params => params, :purchase_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id])
    if @payment_notification.save
      if @payment_notification.status != "Completed"
        redirect_to root_url, :notice => "PayPal failed to authorize the payment. Reason given was - '#{@payment_notification.status}'"
      else
        redirect_to root_url, :notice => "Successfully bought #{@payment_notification.purchase.amount.to_s} credits"
      end
    else
      redirect_to root_url, :notice => "Failed to authorize this payment. Reason is - '#{@payment_notification.errors.full_messages.to_sentence}'" 
    end
  end
end
