module BonusesHelper
  
  def short_status(status)
    if status == "Activated"
      "activated"
    else
      "nothing"
    end
  end
  
end
