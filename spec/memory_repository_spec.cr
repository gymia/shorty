require "./spec_helper"

describe Shorty::MemoryRepository do
  google_entry = Shorty::UrlEntry.new("goog", "http://google.com")

  it "should be able to save url entries" do
    repository = Shorty::MemoryRepository.new
    repository.put(google_entry).should be_true
  end

  it "should be able to find url entries by code" do
    repository = Shorty::MemoryRepository.new
    repository.put(google_entry)

    saved_entry = repository.get(google_entry.code)
    saved_entry.should_not be_nil
    saved_entry.not_nil!.url.should eq(google_entry.url)
  end

  it "should be able to check if the given code is exists" do
    repository = Shorty::MemoryRepository.new
    repository.put(google_entry)
    repository.exists?(google_entry.code).should be_true
  end
end
