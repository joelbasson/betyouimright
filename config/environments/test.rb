Betyouimright::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :tls                  => true,
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "betyouimright.com",
    :user_name            => 'betmaster@betyouimright.com',
    :password             => 'temp1234',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
    
  ENV["HOSTNAME"] = 'http://localhost:3000/'
  ENV["SHORT_HOSTNAME"] = 'www.betyouimright.com/'
  config.cache_store = :dalli_store
  ENV['HEROKU_USER'] = 'joelbasson@me.com' 
  ENV['HEROKU_PASS'] = 'joel6154'
  ENV['HEROKU_APP'] = 'betyouimright'
  ENV['USE_HEROKU_SCALING'] = 'false'
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      :login => "joelbasson_api1.me.com",
      :password => "TYF2DS3APZW8S8MH",
      :signature => "AndSV61P7j5Z4Neh6eVpy4hDFPBOANPc2M6VOrtsI1457Q2zJ8MXLAJg"
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end
