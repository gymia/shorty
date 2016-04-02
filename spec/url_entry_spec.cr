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
end
