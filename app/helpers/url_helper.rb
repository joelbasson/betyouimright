module UrlHelper  
  def with_subdomain(subdomain)
    subdomain = "www" if !subdomain && request.domain(APP_CONFIG["domain_periods"].to_i) != "localhost" && request.domain(APP_CONFIG["domain_periods"].to_i) != "heroku.com"
    subdomain = (subdomain || request.subdomain)  
    subdomain += "." unless subdomain.empty?  
    [subdomain, request.domain(APP_CONFIG["domain_periods"].to_i), request.port_string].join  
  end  
  
  def url_for(options = nil)  
    if options.kind_of?(Hash) && options.has_key?(:subdomain) && options[:subdomain] != false
      options[:host] = with_subdomain(options.delete(:subdomain))
    end  
    super  
  end
  
end