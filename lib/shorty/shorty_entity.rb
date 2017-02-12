require 'date'

module Shorty
  class ShortyEntity
    attr_reader :url, :shortcode, :error, :start_date, :last_seen_date
    attr_reader :redirect_count

    def initialize(args)
      @url            = args.fetch(:url)
      @shortcode      = args.fetch(:shortcode, nil)
      @start_date     = args.fetch(:start_date, nil)
      @last_seen_date = args.fetch(:last_seen_date, nil)
      @redirect_count = args.fetch(:redirect_count, 0).to_i
      @redis          = Shorty.redis
      @validator      = Shortcode::Validator.new(shortcode)
    end

    def create
      @error = validator.perform
      return false if error

      @shortcode = set_shortcode
      redis.mapped_hmset(
         shortcode,
        {
          url: url, start_date: current_datetime,
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
        @url            = hsh.fetch(:url)
        @shortcode      = hsh.fetch(:shortcode, nil)
        @start_date     = hsh.fetch(:start_date, nil)
        @last_seen_date = hsh.fetch(:last_seen_date, nil)
        @redirect_count = hsh.fetch(:redirect_count, 0).to_i
      end

      self
    end

    def increment_redirect
      redis.pipelined do
        redis.hset(
          shortcode,
          :last_seen_date,
          current_datetime
        )
        redis.hincrby(shortcode, :redirect_count, 1)
      end

      self.class.find(shortcode)
    end

    def shortened_url
      Shortcode::Generator.shortener(shortcode)
    end

    def to_hash
      # TODO: remove this and mount the hash on the create controller
      { url: url, shortcode: shortcode }#, start_date: start_date,
      #   last_seen_date: last_seen_date, redirect_count: redirect_count
      # }
    end

    private
    attr_reader :redis, :validator, :generator

    def set_shortcode
      validator.qualified? ? shortcode : generate_shortcode
    end

    def generate_shortcode
      Shortcode::Generator.perform(url)
    end

    # TODO: warning: not this class's responsibility
    def current_datetime
      DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end
end
