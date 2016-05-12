require_relative 'repository'
require_relative '../../models/url'
require 'time'

class UrlRepository < Repository

  private def model_class
    URL
  end

  def create(url, shortcode)
    model_class.create(url: url, shortcode: shortcode, start_date: Time.now.utc.iso8601, last_seen_date: nil, redirect_count: 0)
  end

  def get(shortcode)
    model_class.find_by(shortcode: shortcode)
  end

end
