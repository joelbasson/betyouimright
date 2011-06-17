require 'pp'
ActiveResource::Base.logger = Rails.logger

module ActiveResource
  module Formats
    module FbjsonFormat
      extend self
      
      def extension
        "fbjson"
      end
      
      def mime_type
        "application/json"
      end
      
      def encode(hash)
        hash.to_json
      end
      
      def decode(json)
        tmp = JSON.parse(json)
        puts tmp.first
        ActiveSupport::JSON.decode(tmp)
      end
    end
  end
end