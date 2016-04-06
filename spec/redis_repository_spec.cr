require "redis"
require "./spec_helper"

describe Shorty::RedisRepository do
  redis = RedisConnection.new
  repository = Shorty::RedisRepository.new(redis)

  google_entry = Shorty::UrlEntry.new("goog", "http://google.com")

  it "should be able to save url entries" do
    repository.put(google_entry).should be_true
  end

  it "should be able to find url entries by code" do
    repository.put(google_entry)

    saved_entry = repository.get(google_entry.code)
    saved_entry.should_not be_nil
    saved_entry.not_nil!.url.should eq(google_entry.url)

    repository.get("nonexist").should be_nil
  end

  it "should be able to check if the given code is exists" do
    repository.put(google_entry)
    repository.exists?(google_entry.code).should be_true
  end
end

# Mock redis connection object
class RedisConnection < Redis
  @entries = {} of String => String
  
  def get(code)
    @entries[code]?
  end

  def set(key, value)
    @entries[key] = value
    return true
  end
end

