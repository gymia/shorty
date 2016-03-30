require "time"

class Shorty::Shortcode
  MAX_CHARS = 6

  REGEX = /^[0-9a-zA-Z_]{#{MAX_CHARS}}$/
  DESIRED_REGEX = /^[0-9a-zA-Z_]{4,}$/

  POSSIBLE_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWYXZ".chars

  getter code
  property url
  property created_at
  property last_seen_at
  property redirect_count

  def initialize(@code, @url, @created_at = Time.now, @last_seen_at = Time.now, @redirect_count = 0)
  end

  def self.meet_requirements?(content)
    !content.match(DESIRED_REGEX).nil?
  end

  def self.generate
    POSSIBLE_CHARS.sample(MAX_CHARS).join
  end
end
