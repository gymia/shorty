module Shorty
  class Errors
    class << self
      def missing_url
        {message: "url is not present", code: 400}
      end

      def not_found
        {message: "The shortcode cannot be found in the system", code: 404}
      end

      def in_use
        {
          message: "The the desired shortcode is already in use. Shortcodes are case-sensitive.",
          code: 409
        }
      end

      def not_match_requirements
        {
          message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$",
          code: 422
        }
      end
    end
  end
end
