# module OmniAuth
#   module Strategy
#     def full_host
#       case OmniAuth.config.full_host
#         when String
#           OmniAuth.config.full_host
#         when Proc
#           OmniAuth.config.full_host.call(env)
#         else
#           if options[:canvas]
#             APP_CONFIG["canvas_url"]
#           else
#             request.url.split('/auth/')[0]
#           end
#       end
#     end
#   end
# end
# 
# require 'openid/store/filesystem'
# require "openid/fetchers"
# require "mywebbylife_authorization"
# OpenID.fetcher.ca_file = "#{Rails.root}/config/certs/ca-bundle.crt" 
# Rails.application.config.middleware.use OmniAuth::Builder do  
#   provider :twitter, 'AtSWWYAteESuD9q8CeHw', 'HkpgauiFuoUSGZScJ4njpVGT4FLuI8VLLP3G8Aql9RI'  
#   provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :domain => 'gmail.com'   
#   provider :facebook, '104465769636132', 'd6c54950944ebf472fa601719ad6c4e8', :iframe => true, :setup => true  
#   provider :mywebbylife, "m5uKXnULN2g32fdP", "OEi5ihV35yn2BHx1xkBloncfgCcVRsdc"
# end
# require 'omniauth/strategies/facebook'
# 
# module OmniAuth
#   module Strategies
#     class FacebookCanvas < OmniAuth::Strategies::Facebook
#        def name 
#          :facebook_canvas
#        end
#     end
#   end
# end

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Facebookcanvas < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'email,offline_access'
      
      option :client_options, {
        :site => 'https://graph.facebook.com',
        :token_url => '/oauth/access_token'
      }

      option :token_params, {
        :parse => :query
      }

      option :access_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }
      
      uid { raw_info['id'] }
      
      info do
        prune!({
          'nickname' => raw_info['username'],
          'email' => raw_info['email'],
          'name' => raw_info['name'],
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
          'image' => "http://graph.facebook.com/#{uid}/picture?type=square",
          'description' => raw_info['bio'],
          'urls' => {
            'Facebook' => raw_info['link'],
            'Website' => raw_info['website']
          },
          'location' => (raw_info['location'] || {})['name']
        })
      end
      
      credentials do
        prune!({
          'expires' => access_token.expires?,
          'expires_at' => access_token.expires_at
        })
      end
      
      extra do
        prune!({
          'raw_info' => raw_info
        })
      end
      
      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

      def build_access_token
        super.tap do |token|
          token.options.merge!(access_token_options)
        end
      end

      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end
      
      def authorize_params
        super.tap do |params|
          params.merge!(:display => request.params['display']) if request.params['display']
          params[:scope] ||= DEFAULT_SCOPE
        end
      end
      
      private
      
      def prune!(hash)
        hash.delete_if do |_, value| 
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
    end
  end
end

# if Rails.env.production?
#   OmniAuth.config.full_host = "http://localhost:3000"
# elsif Rails.env.test?
#   OmniAuth.config.full_host = "http://apps.facebook.com/betyouimright"
# elsif Rails.env.development?
#   OmniAuth.config.full_host = "http://apps.facebook.com/betyouimright"
# end
