class Subdomain  
  def self.matches?(request)  
    request.subdomain(APP_CONFIG["domain_periods"].to_i).present? && request.subdomain(APP_CONFIG["domain_periods"].to_i) != 'www'  
  end  
end