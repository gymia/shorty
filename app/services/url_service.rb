require_relative '../data/validator/validator'
require_relative '../data/repositories/repository'

class URLService

  def create(url, shortcode)
    if Validator.blank?(shortcode)
      shortcode = generate_shortcode
    end

    short_url = Repository.for(:url).create(url, shortcode)

    short_url
  end

  private

  def generate_shortcode
    SecureRandom.hex(3)
  end
end
