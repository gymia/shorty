require "json"
require "time"

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

    return data
  end

  def self.from_json(code, json_str)
    json = JSON.parse(json_str)

    url = json["url"].to_s
    created_at = Time.epoch(json["created_at"].as_i)
    last_seen_at = Time.epoch(json["last_seen_at"].as_i)
    redirect_count = json["redirect_count"].as_i

    UrlEntry.new(code, url, created_at, last_seen_at, redirect_count)
  end

  def to_json
    String.build do |io|
      io.json_object do |obj|
        obj.field "url", @url
        obj.field "created_at", @created_at.epoch
        obj.field "last_seen_at", @last_seen_at.epoch
        obj.field "redirect_count", @redirect_count
      end
    end
  end
end
