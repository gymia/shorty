require 'digest'
require 'uri'


module Shorty
  module Shortcode
    class Generator
      def self.perform(url)
        encoded = Digest::MD5.hexdigest(url)
        encoded.reverse.scan(/[0-9a-zA-Z_]{6}/).first
      end

      def self.shortener(shortcode=nil)
        URI::HTTP.build(host: shortcode).to_s if shortcode
      end
    end
  end
end
