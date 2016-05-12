require_relative '../data/validator/validator'
require_relative '../data/repositories/repository'

class ShortCodeService

  def create(url, shortcode)
    shortcode = generate_shortcode if shortcode.nil?

    Repository.for(:shortcode).create(url, shortcode)
  end

  def get(shortcode)
    Repository.for(:shortcode).get(shortcode)
  end

  def update(url)
    update_counter url
    update_last_seen_date url
  end

  def get_stats(shortcode)
    short_code = get shortcode

    return nil if short_code.nil?

    response = Hash.new
    response[:startDate] = short_code.start_date
    response[:lastSeenDate] = short_code.last_seen_date unless short_code.redirect_count == 0
    response[:redirect_count] = short_code.redirect_count

    response
  end

  private

  def generate_shortcode
    SecureRandom.hex(3)
  end

  def update_counter(url)
    Repository.for(:shortcode).set(:redirect_count, url.redirect_count + 1)
  end

  def update_last_seen_date(url)
    Repository.for(:shortcode).set(:last_seen_date, Time.now.utc.iso8601)
  end
end
