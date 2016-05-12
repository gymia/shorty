require './app/data/validator/validator'
require './app/data/repositories/repository'

class ShortCodeService

  def create(url, shortcode)
    shortcode = generate_shortcode if shortcode.nil?

    Repository.for(:shortcode).create(url, shortcode)
  end

  def get(shortcode)
    Repository.for(:shortcode).get(shortcode)
  end

  def update(shortcode)
    update_counter shortcode
    update_last_seen_date shortcode
  end

  def get_stats(shortcode)
    short_code_model = get shortcode

    return nil if short_code_model.nil?

    response = Hash.new
    response[:startDate] = short_code_model.start_date
    response[:lastSeenDate] = short_code_model.last_seen_date unless short_code_model.redirect_count == 0
    response[:redirectCount] = short_code_model.redirect_count

    response
  end

  private

  def generate_shortcode
    SecureRandom.hex(3)
  end

  def update_counter(short_code_model)
    Repository.for(:shortcode).set(short_code_model, :redirect_count, short_code_model.redirect_count + 1)
  end

  def update_last_seen_date(short_code_model)
    Repository.for(:shortcode).set(short_code_model, :last_seen_date, Time.now.utc.iso8601)
  end
end
