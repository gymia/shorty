require "time"

class Shorty::CodeGenerator
  MAX_CHARS = 6

  REGEX = /^[0-9a-zA-Z_]{#{MAX_CHARS}}$/
  DESIRED_REGEX = /^[0-9a-zA-Z_]{4,}$/

  POSSIBLE_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWYXZ".chars

  def initialize()
  end

  def self.valid?(content)
    !content.match(DESIRED_REGEX).nil?
  end

  def generate
    POSSIBLE_CHARS.sample(MAX_CHARS).join
  end
end
