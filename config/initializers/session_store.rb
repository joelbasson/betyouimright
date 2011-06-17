# Be sure to restart your server when you modify this file.

require 'action_dispatch/middleware/session/dalli_store'
Betyouimright::Application.config.session_store :dalli_store, :namespace => 'sessions', :key => '_betyouimright_session', :expire_after => 24.hours

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Betyouimright::Application.config.session_store :active_record_store
