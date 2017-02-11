require 'base64'

module Shorty
  module Shortcode
    class Generator
      def self.run(url)
        url = "http://#{url}" unless url =~ /http/
        encoded = Base64.urlsafe_encode64(url)
        encoded.reverse.scan(/[0-9a-zA-Z_]{6}/).last
      end
    end
  end
end
