module ForumHelper
  
  def is_owner(model)
    user_signed_in? && model.user == current_user
  end
  
  def some_html(s, blockquotes = false) 
      s = h(s)
      # converting newlines 
      s.gsub!(/\r\n?/, "\n") 
      # 
      # # escaping HTML to entities 
      # s = s.to_s.gsub('&quot;', '"').gsub('&lt;', '<').gsub('&gt;', '>')
      if s.include? "BETID"
        @bet = Bet.find_by_id(s.split("BETID")[1].to_i) 
        if @bet
          s = s.gsub("BETID#{@bet.id}BETID", link_to("bet", url_for(:only_path => false, :controller => 'bets', :action => 'show', :id => @bet.to_param, :subdomain => false), :alt => @bet.title, :title => @bet.title ))
        end
      end
      # blockquote tag support 
      s.gsub!("&lt;blockquote&gt;", "<blockquote>") if blockquotes
      s.gsub!("&lt;/blockquote&gt;", "</blockquote>") if blockquotes
      
      raw s     
  end
end