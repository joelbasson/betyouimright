base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @other_routes.each do |other|
    xml.url {
      xml.loc(root_url + other)
      xml.lastmod("2011-04-01")
      xml.changefreq("monthly")
      other == "" ? xml.priority("0.9") : xml.priority("0.5")
    }
  end
  @bets.each do |bet|
    xml.url {
      xml.loc(url_for(:only_path => false, :controller => 'bets', :action => 'show', :id => bet.to_param))
      xml.lastmod(bet.updated_at)
      xml.changefreq("monthly")
      xml.priority("0.5")
    }
    if bet.comments.size > Comment.per_page
      for i in 2..(bet.comments.size / Comment.per_page).ceil
        xml.url {
          xml.loc(url_for(:only_path => false, :controller => 'bets', :action => 'show', :id => bet.to_param, :page => i))
          xml.lastmod(bet.updated_at)
          xml.changefreq("daily")
          xml.priority("0.4")
        }
      end
    end
  end
  @topics.each do |topic|
    xml.url {
      xml.loc(url_for(:only_path => false, :controller => 'topics', :action => 'show', :id => topic.to_param))
      xml.lastmod(topic.posts.last.updated_at)
      xml.changefreq("daily")
      xml.priority("0.5")
    }
    if topic.posts.size > 10
      for i in 2..(topic.posts.size / 10).ceil
        xml.url {
          xml.loc(url_for(:only_path => false, :controller => 'topics', :action => 'show', :id => topic.to_param, :page => i))
          xml.lastmod(topic.posts.last.updated_at)
          xml.changefreq("daily")
          xml.priority("0.5")
        }
      end
    end
  end
  
end