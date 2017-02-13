module Shorty
  module Shortcode
    class Validator
      def initialize(shortcode)
        @shortcode = shortcode
      end

      def qualified?
        shortcode =~ /^[0-9a-zA-Z_]{4,}$/
      end

      def perform
        if shortcode
          return Errors.in_use if in_use?
          return Errors.not_match_requirements if !qualified?
        end
      end

      private
      attr_reader :shortcode

      def in_use?
        Models::Shorty.find(shortcode)
      end
    end
  end
end
