ISO8016 = "%FT%TZ"

class Shorty::UrlEntry
  getter code
  getter url
  getter created_at
  getter last_seen_at
  getter redirect_count

  def initialize(@code, @url, @created_at = Time.now.to_utc, @last_seen_at = Time.now.to_utc, @redirect_count = 0)
  end

  def visit
    UrlEntry.new(@code, @url, @created_at, Time.now.to_utc, @redirect_count + 1)
  end

  def stats
    data = { 
      "startDate" => @created_at.to_s(ISO8016),
      "redirectCount" => @redirect_count
    }

    if @redirect_count > 0
      data["lastSeenDate"] = @last_seen_at.to_s(ISO8016)
    end

    data
  end
end
