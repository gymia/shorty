module Shorty
  module Shortcode
    class Validator
      def initialize(shortcode)
        @shortcode = shortcode
      end

      def qualified?
        shortcode.nil? || shortcode.match(/^[0-9a-zA-Z_]{4,}$/)
      end

      def perform
        if in_use?
          Errors.in_use
        elsif !qualified?
          Errors.not_match_requirements
        end
      end

      private
      attr_reader :shortcode

      def in_use?
        Shorty::ShortyEntity.find(shortcode) if shortcode
      end
    end
  end
end
