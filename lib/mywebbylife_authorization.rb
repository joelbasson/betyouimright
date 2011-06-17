require 'omniauth/core'
require 'omniauth/oauth'
module OmniAuth
  module Strategies
    class Mywebbylife < OAuth2

      # receive parameters from the strategy declaration and save them
      def initialize(app, client_id = nil, client_secret = nil, options = {}, &block)
        super(app, :mywebbylife, client_id, client_secret, {:site => 'http://localhost:3002/oauth/authorize'}, options, &block)
      end
      
      def user_data
        @data ||= MultiJson.decode(@access_token.get('/oauth/user', {}, { "Accept-Language" => "en-us,en;"}))
      end

      def request_phase
        options[:scope] ||= "email"
        super
      end
      
      def user_info
        {
          'nickname' => user_data["nickname"],
          'email' => (user_data["email"] if user_data["email"]),
          'first_name' => user_data["first_name"],
          'last_name' => user_data["last_name"],
          'name' => "#{user_data['first_name']} #{user_data['last_name']}"
        }
      end  

      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => user_data['uid'],
          'user_info' => user_info,
          'extra' => {'user_hash' => user_data}
        })
      end
      
    end
  end
end