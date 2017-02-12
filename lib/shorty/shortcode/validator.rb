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
          {
            message: "The the desired shortcode is already in use. Shortcodes are case-sensitive.",
            code: 409
          }
        elsif !qualified?
          {
            message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$",
            code: 422
          }
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
