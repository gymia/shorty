module Shorty
  class ShortyEntity
    attr_reader :url, :shortcode, :error

    # TODO: use args with fetch(value,default)
    def initialize(url, shortcode=nil)
      @url       = url
      @shortcode = shortcode
      @redis     = Shorty.redis
      @validator = Shortcode::Validator.new(shortcode)
    end

    def create
      @error = validator.perform
      return false if error

      @shortcode = set_shortcode
      redis.set(shortcode, url)
      self
    end

    def self.find(shortcode)
      result = Shorty.redis.get(shortcode)

      self.new(result, shortcode) if result
    end

    def shortened_url
      Shortcode::Generator.shortener(shortcode)
    end

    def to_hash
      {url: url, shortcode: shortcode}
    end

    private
    attr_reader :redis, :validator, :generator

    def set_shortcode
      shortcode && validator.qualified? ? shortcode : Shortcode::Generator.perform(url)
    end
  end
end
