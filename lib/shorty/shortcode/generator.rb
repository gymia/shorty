require 'base64'
require 'uri'


module Shorty
  module Shortcode
    class Generator
      def self.perform(url)
        url = "http://#{url}" unless url =~ /http/
        encoded = Base64.urlsafe_encode64(url)
        encoded.reverse.scan(/[0-9a-zA-Z_]{6}/).last
      end

      def self.shortener(shortcode=nil)
        URI::HTTP.build(host: shortcode).to_s if shortcode
      end
    end
  end
end
