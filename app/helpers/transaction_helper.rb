module TransactionHelper
  
  def link_description_bet(transaction)
    if transaction.bet
      return h(transaction.description) + " " + link_to("Bet #" + transaction.bet.id.to_s, transaction.bet, :class => 'remote-link')
    else
      return h(transaction.description)
    end  
  end
    
end
