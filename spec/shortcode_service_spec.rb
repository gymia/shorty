require './app/services/short_code_service'
require_relative 'factories/short_code'

describe ShortCodeService do
  let(:shortcode) { ShortCodeService.new }
  describe '.create' do
    it "should create a shortcode in the database with a random shortcode if none provided" do
      short_code = shortcode.create "www.google.com", nil
      expect(short_code.shortcode).not_to eq(nil)
    end

    it "should create a shortcode in the database with the shortcode provided" do
      short_code = shortcode.create "www.google.com", "goog"
      expect(short_code.shortcode).to eq("goog")
    end
  end

  describe '.get' do
    it "should return a shortcode model if the provided shortcode exists in the database" do
      create :short_code
      short_code = shortcode.get "shortcode"
      expect(short_code).not_to eq(nil)
      expect(short_code).to be_a ShortCode
    end

    it "should return nil if the shortcode does not exist in the database" do
      short_code = shortcode.get "dummy"
      expect(short_code).to eq(nil)
    end
  end

  describe '.update' do
    it "should update the counter of a shortcode" do
      create :short_code, shortcode: "shorty4",redirect_count: 0
      short_code = shortcode.get "shorty4"
      shortcode.update short_code
      expect(short_code.redirect_count).to eq(1)
    end

    it "should update the last seen date of a shortcode" do
      short_code = shortcode.get "shorty4"
      shortcode.update short_code
      expect(short_code.last_seen_date).to eq(Time.now.utc.iso8601)
    end
  end

  describe '.get_stats' do
    it "should retrieve the stats of a shortcode when found in the database" do
      response = shortcode.get_stats "shorty4"
      expect(response.keys).to contain_exactly(:redirectCount, :lastSeenDate, :startDate)
      expect(response[:lastSeenDate]).to be_a DateTime
      expect(response[:lastSeenDate]).to eq(Time.now.utc.iso8601)
      expect(response[:startDate]).to be_a DateTime
      expect(response[:redirectCount]).to eq(2)
    end
  end
end
