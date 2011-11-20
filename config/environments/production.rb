Betyouimright::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( facebook.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => 'www.betyouimright.com' }
  config.action_mailer.smtp_settings = {
    :tls                  => true,
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "betyouimright.com",
    :user_name            => 'betmaster@betyouimright.com',
    :password             => 'temp1234',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
    
  ENV["HOSTNAME"] = 'http://www.betyouimright.com/'
  ENV["SHORT_HOSTNAME"] = 'www.betyouimright.com/'
  config.cache_store = :dalli_store
  ENV['HEROKU_USER'] = 'joelbasson@me.com' 
  ENV['HEROKU_PASS'] = 'joel6154'
  ENV['HEROKU_APP'] = 'betyouimright'
  ENV['USE_HEROKU_SCALING'] = 'true'
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      :login => "betmas_1300139163_biz_api1.betyoulose.com",
      :password => "1300139171",
      :signature => "AkaK0T7uhUZkp9avb85hmsjvZGGvAeTRApZekXtyQx1E6GRuTkCVozJY"
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
  
end
