require "time"
require "./repositories/base_repository"

class Shorty::CodeGenerator
  MAX_CHARS = 6

  REGEX = /^[0-9a-zA-Z_]{#{MAX_CHARS}}$/
  DESIRED_REGEX = /^[0-9a-zA-Z_]{4,}$/

  POSSIBLE_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWYXZ".chars

  def initialize(@repository : BaseRepository)
  end

  def valid?(desired_code)
    !desired_code.match(DESIRED_REGEX).nil?
  end

  def generate
    while code = POSSIBLE_CHARS.sample(MAX_CHARS).join
      unless @repository.exists?(code)
        break
      end
    end

    return code
  end
end
