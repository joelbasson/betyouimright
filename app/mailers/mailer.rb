class Mailer < ActionMailer::Base
  extend HerokuDjAutoScale 
  layout 'mailer'
  add_template_helper(BetsHelper)
  default :from => "BetMaster <#{APP_CONFIG["betmaster_email"]}>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.invoice.subject
  #
  def new_bet(bet)
    @bet = bet
    mail(:to => "#{@bet.user.display_name} <#{@bet.user.email}>", :from => "BetMaster <#{APP_CONFIG["betmaster_email"]}>", :bcc => "BetMaster <#{APP_CONFIG['admin_email']}>, BetMaster2 <#{APP_CONFIG['admin2_email']}>", :subject => "You created a new bet at #{APP_CONFIG["application_name"]}")
  end
  
  def bet_decided(bet)
    @bet = bet
    mail(:to => "#{@bet.user.display_name} <#{@bet.user.email}>", :from => "BetMaster <#{APP_CONFIG["betmaster_email"]}>", :bcc => "BetMaster <#{APP_CONFIG['admin_email']}>, BetMaster2 <#{APP_CONFIG['admin2_email']}>", :subject => "Bet decided at #{APP_CONFIG["application_name"]}")
  end
  
  def new_challenge(bet)
    @bet = bet
    mail(:to => "#{@bet.challengee.display_name} <#{@bet.challengee.email}>", :from => "BetMaster <#{APP_CONFIG["betmaster_email"]}>", :bcc => "BetMaster <#{APP_CONFIG['admin_email']}>, BetMaster2 <#{APP_CONFIG['admin2_email']}>", :subject => "You were challenged to a new bet at #{APP_CONFIG["application_name"]}")
  end

end
