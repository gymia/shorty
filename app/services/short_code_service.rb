require_relative '../data/validator/validator'
require_relative '../data/repositories/repository'

class ShortCodeService

  def create(url, shortcode)
    shortcode = generate_shortcode if shortcode.nil?

    Repository.for(:shortcode).create(url, shortcode)
  end

  def get(shortcode)
    url = Repository.for(:shortcode).get(shortcode)

    return nil if url.nil?

    update_counter url
    update_last_seen_date url

    url
  end

  private

  def generate_shortcode
    SecureRandom.hex(3)
  end

  def update_counter(url)

  end

  def update_last_seen_date(url)

  end
end
