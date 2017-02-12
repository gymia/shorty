require 'date'

module Shorty
  class ShortyEntity
    attr_reader :url, :shortcode, :error, :start_date, :last_seen_date
    attr_reader :redirect_count

    def initialize(args)
      update_attributes(args)

      @redis     = Shorty.redis
      @validator = Shortcode::Validator.new(shortcode)
    end

    def create
      @error = validator.perform
      return false if error

      @shortcode = set_shortcode
      redis.mapped_hmset(
        shortcode,
        {
          url: url,
          start_date: DateTime.shorty_current,
          redirect_count: redirect_count
        }
      )

      self.class.find(shortcode)
    end

    def self.find(shortcode)
      hsh = Shorty.redis.hgetall(shortcode).symbolize_keys

      if hsh.any?
        hsh.merge!({shortcode: shortcode})
        self.new(hsh)
      end
    end

    def reload
      hsh = redis.hgetall(shortcode).symbolize_keys

      if hsh.any?
        hsh.merge!({shortcode: shortcode})
        update_attributes(hsh)
      end

      self
    end

    def increment_redirect
      redis.pipelined do
        redis.hset(shortcode, :last_seen_date, DateTime.shorty_current)
        redis.hincrby(shortcode, :redirect_count, 1)
      end

      self.class.find(shortcode)
    end

    def shortened_url
      Shortcode::Generator.shortener(shortcode)
    end

    private
    attr_reader :redis, :validator, :generator

    def set_shortcode
      validator.qualified? ? shortcode : generate_shortcode
    end

    def generate_shortcode
      Shortcode::Generator.perform(url)
    end

    def update_attributes(hsh)
      @url            = hsh.fetch(:url)
      @shortcode      = hsh.fetch(:shortcode, nil)
      @start_date     = hsh.fetch(:start_date, nil)
      @last_seen_date = hsh.fetch(:last_seen_date, nil)
      @redirect_count = hsh.fetch(:redirect_count, 0).to_i
    end
  end
end
