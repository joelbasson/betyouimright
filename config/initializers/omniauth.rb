module OmniAuth
  module Strategy
    def full_host
      case OmniAuth.config.full_host
        when String
          OmniAuth.config.full_host
        when Proc
          OmniAuth.config.full_host.call(env)
        else
          if options[:canvas]
            APP_CONFIG["canvas_url"]
          else
            request.url.split('/auth/')[0]
          end
      end
    end
  end
end

require 'openid/store/filesystem'
require "openid/fetchers"
require "mywebbylife_authorization"
OpenID.fetcher.ca_file = "#{Rails.root}/config/certs/ca-bundle.crt" 
Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'AtSWWYAteESuD9q8CeHw', 'HkpgauiFuoUSGZScJ4njpVGT4FLuI8VLLP3G8Aql9RI'  
  provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :domain => 'gmail.com'   
  provider :facebook, '104465769636132', 'd6c54950944ebf472fa601719ad6c4e8', :iframe => true, :setup => true  
  provider :mywebbylife, "m5uKXnULN2g32fdP", "OEi5ihV35yn2BHx1xkBloncfgCcVRsdc"
end
