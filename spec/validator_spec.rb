require './app/data/validator/validator'
require_relative 'factories/short_code'

describe Validator do
  let(:validator) { Validator }
  describe '.blank?' do
    it "should return true if a value is empty" do
      blank = validator.blank?("")

      expect(blank).to eq(true)
    end

    it "should return false when a value is filled" do
      blank = validator.blank?("value")

      expect(blank).to eq(false)
    end
  end

  describe '.exists?' do
    it "should return true if a value exists in the database" do
      create :short_code, shortcode: "random"
      exists = validator.exists?("random")

      expect(exists).to eq(true)
    end

    it "should return false if a value is not present in the database" do
      exists = validator.exists?("value")

      expect(exists).to eq(false)
    end
  end

  describe '.match?' do
    it "should return true if it matches ^[0-9a-zA-Z_]{4,}$" do
      match = validator.match?("google")

      expect(match).to eq(true)
    end

    it "should return false if it doesn't matches ^[0-9a-zA-Z_]{4,}$" do
      match = validator.match?("#googl@e")

      expect(match).to eq(false)
    end
  end
end
