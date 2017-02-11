require 'json'

module Shorty
  class ShortyEntity
    attr_reader :url, :shortcode, :error

    def initialize(url, shortcode=nil)
      @url       = url
      @shortcode = shortcode
      @error     = {}
      @redis     = Shorty.redis
    end

    def create
      validate_shortcode
      return false if error && error.any?

      @shortcode = set_shortcode
      redis.set(shortcode, url)
      self
    end

    def to_hash
      {url: url, shortcode: shortcode}
    end

    private
    attr_reader :redis

    # TODO: move all this validation logic and errors to Validator class as
    # dependency injection
    def in_use?
      redis.get(shortcode) if shortcode && !shortcode.empty?
    end

    def url_exist?
      redis.get(url) if shortcode.empty?
    end

    def valid?
      Shortcode::Validator.qualified?(shortcode)
    end

    def set_shortcode
      shortcode && valid? ? shortcode : Shortcode::Generator.run(url)
    end

    def validate_shortcode
      @error = if in_use?
        {
          message: "The the desired shortcode is already in use. Shortcodes are case-sensitive.",
          code: 409
        }
      elsif !valid?
        {
          message: "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$",
          code: 422
        }
      end
    end
  end
end
