atom_feed do |feed|
  feed.link("rel" => "first", "href" => url_for(:only_path => false, :controller => 'bets', :action => 'feed'))
  feed.link("rel" => "next", "href" => url_for(:only_path => false, :controller => 'bets', :action => 'feed', :page => @bets.next_page ))
  feed.link("rel" => "last", "href" => url_for(:only_path => false, :controller => 'bets', :action => 'feed', :page => @bets.total_pages ))
  feed.title("#{APP_CONFIG["application_name"]} - Latest Bets - page #{@bets.current_page}")
  feed.updated(@bets.first.updated_at)
  
  for bet in @bets
    next if bet.updated_at.blank?
    feed.entry(bet) do |entry|
      entry.title(bet.title)
      entry.content(bet.description, :type => 'html')
      entry.url(url_for(:only_path => false, :controller => 'bets', :action => 'show', :id => bet.to_param))
      entry.updated(bet.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
      entry.author do |author|
        author.name(bet.user.display_name)
      end
    end
  end
end