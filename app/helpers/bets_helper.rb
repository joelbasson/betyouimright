module BetsHelper
  
  def wagercollection
    startAmount = 20
    stepAmount = 20
    endAmount = 500
    wagersCollection = Array.new
    startAmount.step(endAmount, stepAmount) { |i| wagersCollection << [i.to_s + " credits", i] }
    return wagersCollection
  end
  
  def ending(bet)
    if bet.status == "Undecided"
      return "Ends #{bet.end_date.strftime("%a %d %b %Y")}"
    else
      return "Ended #{bet.end_date.strftime("%a %d %b %Y")}"
    end
  end
    
  def taunt(bet)
    if bet.status == "Undecided"
      return  "says '#{APP_CONFIG["human_application_name"]}!'"
    else
      return "#{bet.status} the bet!"
    end    
  end    
    
  def most_confident(bet)
    stats = bet.most_wagers
    user = User.find(stats.user_id)
    raw "The most confident person is #{link_to user.display_name, publicprofile_path(user)} who has bet #{stats.amount.to_s} times on this bet"
  end
  
  def fb_most_confident(bet)
    stats = bet.most_wagers
    user = User.find(stats.user_id)
    raw "The most confident person is #{link_to user.display_name, publicprofile_path(user), :remote => true} who has bet #{stats.amount.to_s} times on this bet"
  end
    
  def fb_like(bet = nil)
    if bet
      raw "<fb:like href='#{url_for(:only_path => false, :controller => 'bets', :action => 'show', :id => bet.id)}' show_faces='false' width='285' font=''></fb:like>"     
    else
        raw "<fb:like href='#{root_url}' show_faces='false' width='285' font=''></fb:like>"
    end
  end  

end
