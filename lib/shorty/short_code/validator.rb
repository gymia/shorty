module Shorty
  module Shortcode
    class Validator
      def self.qualified?(shortcode)
        shortcode.nil? || shortcode.match(/^[0-9a-zA-Z_]{6}$/)
      end
    end
  end
end
