module ApplicationHelper
  
  def error_div_for(model)
      raw  %{<div id="errors_for_#{model.class.name.underscore}"></div>}
  end
  
  def get_buy_credit_value
    APP_CONFIG["buy_credit_value"].to_d
  end
  
  def get_sell_credit_value
    APP_CONFIG["sell_credit_value"].to_d
  end
  
  def def_cur
    APP_CONFIG["default_currency"]
  end

  def is_iphone?
    request.user_agent =~ /iPhone|iPod/
  end
  
  def is_ipad?
    request.user_agent =~ /iPad/
  end
  
  def create_flash_messages(flash, delete = false)
    flashes = ""
    flash.each do |name, msg|
	    flashes += content_tag :div, msg, :class => "flash #{name}", :style => 'display: none'
	  end
	  if delete
	    flash.clear
    end
	  return raw(flashes)
  end
  
  def create_flash_messages_from_model(error_model)
    flashes = ""
    error_model.errors.each do |name, msg|
	    flashes += content_tag :div, msg, :class => "flash error", :style => 'display: none'
	  end
	  return raw(flashes)
  end
  
  def get_daily_quote
    url = "http://feeds.feedburner.com/brainyquote/QUOTEFU.xml"
    xml = Net::HTTP.get(URI.parse(url))
    doc, quotes = REXML::Document.new(xml), []
    item = doc.elements['rss/channel/item']
    return item.elements['description'].text + " - " + item.elements['title'].text 
  rescue Exception
    return "No internet connection"
  end
  
  def google_analytics(id = nil)
    html = content_tag(:script, :type => 'text/javascript') do
      "var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '#{id}']);
      _gaq.push(['_setDomainName', '.#{APP_CONFIG["domain_name"]}']);
      _gaq.push(['_trackPageview']);
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })()"
    end
    html if !id.blank? && Rails.env.production?
  end
  
  def cache_if (condition, name, options = {}, &block)
    if condition
      cache(name, options, &block)
    else
      capture(&block)
    end
  end
  
  def sortable(column, title = nil)  
      title ||= column.titleize  
      css_class = (column == sort_column) ? "current #{sort_direction}" : nil  
      direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}  
    end
  
end
