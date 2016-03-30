class Shorty::UrlEntry
  getter code
  getter url
  getter created_at
  getter last_seen_at
  getter redirect_count

  def initialize(@code, @url, @created_at = Time.now, @last_seen_at = Time.now, @redirect_count = 0)
  end

  def visit
    UrlEntry.new(@code, @url, @created_at, Time.now, @redirect_count + 1)
  end
end
