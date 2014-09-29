class ShortCode < ActiveRecord::Base

  validates_format_of :shortcode, with: /\A[0-9a-zA-Z_]{4,}\z/
  validates_uniqueness_of :shortcode, case_sensitive: false

  before_validation(on: :create) do
    self.shortcode = generate if self.shortcode.nil?
  end

  def generate
    shortcode = ''
    loop do
      string = SecureRandom.hex
      min_length = Random.rand(4..6)
      start_char = Random.rand(0..string.length-min_length)
      shortcode = string[start_char, min_length]
      break if ShortCode.new(shortcode: shortcode).valid?
    end
    shortcode
  end

end
