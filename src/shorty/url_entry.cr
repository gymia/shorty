class Shorty::UrlEntry
  def initialize(@code, @url, @created_at = Time.now, @last_seen_at = Time.now, @redirect_count = 0)
  end
end
