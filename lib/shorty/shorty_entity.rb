require 'rack/router'
require 'json'

module Shorty
  class ShortyEntity
    attr_reader :url, :shortcode, :errors

    def initialize(url, shortcode=nil)
      @url       = url
      @shortcode = shortcode
      @errors    = { exists: nil, invalid: nil }
      @redis     = Shorty.redis
    end

    def create
      validate_shortcode
      return false if errors.values.any?

      @shortcode = Shortcode::Generator.run
      redis.set(shortcode, url)
      self
    end

    private
    attr_reader :redis

    # TODO: move all this validation logic and errors to Validator class as
    # dependency injection
    def exist?
      redis.get(shortcode) if shortcode && !shortcode.empty?
    end

    def valid?
      Shortcode::Validator.qualified?(shortcode)
    end

    def validate_shortcode
      errors[:exists]  = "shortcode in use" if exist?
      errors[:invalid] = "shortcode is not valid" unless valid?
    end
  end
end
