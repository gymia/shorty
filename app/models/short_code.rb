class ShortCode < ActiveRecord::Base

  validates_format_of :short_code, with: /\A[0-9a-zA-Z_]{4,}\z/
  validates_uniqueness_of :short_code

  def generate
    short_code = ''
    loop do
      string = SecureRandom.hex
      min_length = Random.rand(4..6)
      start_char = Random.rand(0..string.length-min_length)
      short_code = string[start_char, min_length]
      break if ShortCode.create(short_code: short_code).valid?
    end
    short_code
  end
end
