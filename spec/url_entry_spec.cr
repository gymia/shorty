require "./spec_helper"

describe Shorty::UrlEntry do
  it "should be able to increment last seen and redirect count data on visit" do
    code = Shorty::CodeGenerator.new().generate

    url_entry = Shorty::UrlEntry.new(code, "http://google.com")

    Fiber.sleep(0.00001)
    visited_entry = url_entry.visit

    (visited_entry.last_seen_at > url_entry.last_seen_at).should be_true
    (visited_entry.redirect_count > url_entry.redirect_count).should be_true
  end
end
