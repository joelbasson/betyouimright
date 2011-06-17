class StaticController < ApplicationController
  respond_to :html, :xml, :json, :js, :fb
  layout Proc.new { is_facebook? ? false : 'application' }

  def about
  end
  
  def how
  end
  
  def terms  
  end
  
  def contact
  end
    
  def privacy
  end
  
  def login
  end
    
end
