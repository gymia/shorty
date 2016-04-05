require "./spec_helper"

describe Shorty::UrlEntry do
  it "should be able to increment last seen and redirect count data on visit" do
    url_entry = Shorty::UrlEntry.new("goog", "http://google.com")

    Fiber.sleep(0.00001)
    visited_entry = url_entry.visit

    (visited_entry.last_seen_at > url_entry.last_seen_at).should be_true
    (visited_entry.redirect_count > url_entry.redirect_count).should be_true
  end

  it "should extract lastSeenDate only for visited url entries" do
    url_entry = Shorty::UrlEntry.new("googl", "http://google.com")
    url_entry.stats["lastSeenDate"]?.should be_nil

    visited_url_entry = url_entry.visit
    visited_url_entry.stats["lastSeenDate"].should_not be_nil
  end

  it "should be able to serialize itself as json" do
    now = Time.now.to_utc
    epoch = now.epoch

    url_entry = Shorty::UrlEntry.new("googl", "http://google.com", now, now)

    json = url_entry.to_json

    hash = {
      "url"            => "http://google.com",
      "created_at"     => epoch,
      "last_seen_at"   => epoch,
      "redirect_count" => 0
    }

    json.should eq(hash.to_json)
  end

  it "should be able to deserialize itself from json" do
    now = Time.now.to_utc
    epoch = now.epoch

    json_str = {
      "url"            => "http://google.com",
      "created_at"     => epoch,
      "last_seen_at"   => epoch,
      "redirect_count" => 0
    }.to_json

    entry = Shorty::UrlEntry.from_json("goog", json_str)

    entry.url.should eq("http://google.com")
    entry.created_at.epoch.should eq(epoch)
    entry.last_seen_at.epoch.should eq(epoch)
    entry.redirect_count.should eq(0)
  end
end
