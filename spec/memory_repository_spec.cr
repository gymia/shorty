require "./spec_helper"

describe Shorty::MemoryRepository do
  it "should be able to save url entries" do
    repository = Shorty::MemoryRepository.new

    code1 = Shorty::CodeGenerator.new().generate
    entry1 = Shorty::UrlEntry.new(code1, "http://google.com")

    repository.put(entry1).should be_true
  end

  it "should be able to find url entries by code" do
    repository = Shorty::MemoryRepository.new
    
    code1 = Shorty::CodeGenerator.new().generate
    entry1 = Shorty::UrlEntry.new(code1, "http://google.com")

    repository.put(entry1)
    saved_entry = repository.get(code1)

    saved_entry.should_not be_nil
    saved_entry.not_nil!.url.should eq(entry1.url)
  end

  it "should be able to check if the given code is exists" do
    repository = Shorty::MemoryRepository.new
    
    code1 = Shorty::CodeGenerator.new().generate
    entry1 = Shorty::UrlEntry.new(code1, "http://google.com")

    repository.put(entry1)
    repository.exists?(code1).should be_true
  end
end
