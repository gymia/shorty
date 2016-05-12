require File.expand_path '../spec_helper.rb', __FILE__

require_relative 'factories/short_code'

describe "Short code API" do
  describe 'post /shorten' do
    it "should create a random short url when no shortcode is provided" do
      post '/shorten', {:url => "www.google.com"}.to_json
      expect(last_response).to be_created
      expect(last_response.header['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('shortcode')
    end

    it "should create a short url with the shortcode provided" do
      post '/shorten', {:url => "www.google.com", :shortcode => "google"}.to_json
      expect(last_response).to be_created
      expect(last_response.header['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('shortcode')
      expect(json['shortcode']).to eq('google')
    end

    it "should return a bad request when no url is provided" do
      post '/shorten', {:url => ""}.to_json
      expect(last_response).to be_bad_request
      expect(last_response.header['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('message')
      expect(json['message']).to eq('URL is not provided.')
    end

    it "should return a conflict when the shortcode is provided and already exists" do
      create(:short_code, shortcode: "shortyurl")
      post '/shorten', {:url => "www.google.com", :shortcode => "shortyurl"}.to_json
      expect(last_response.status).to eq(409)
      expect(last_response.header['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('message')
      expect(json['message']).to eq('Shortcode already exists')
    end

    it "should return unprocessable entity when a shortcode does not match the regex" do
      post '/shorten', {:url => "www.google.com", :shortcode => "g00@le"}.to_json
      expect(last_response.status).to eq(422)
      expect(last_response.header['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('message')
      expect(json['message']).to eq("Shortcode doesn't match regex")
    end
  end

  describe 'get /:shortcode' do
    it "should redirect you to a location when shortcode is found in the system" do
      get '/google'
      expect(last_response.status).to eq(302)
      expect(last_response.header['Location']).to eq('www.google.com')
    end

    it "should return not found when the shortcode is not found in the system" do
      get '/shortcode'
      expect(last_response).to be_not_found
      expect(last_response.header['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('message')
      expect(json['message']).to eq('The shortcode cannot be found in the system')
    end
  end

  describe 'get /:shortcode/stats' do
    it "should return the stats of a shortcode when the shortcode is found in the system" do
      get '/google/stats'
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('startDate', 'redirectCount')
    end

    it "should show the lastSeenDate when /:shortcode is called at least once" do
      create :short_code
      get '/shortcode/stats'
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('startDate', 'redirectCount', 'lastSeenDate')
    end

    it "should return not found when the shortcode is not in the system" do
      get '/shortycode/stats'
      expect(last_response).to be_not_found
      expect(last_response.headers['Content-Type']).to eq('application/json')
      json = parse_json last_response
      expect(json.keys).to contain_exactly('message')
      expect(json['message']).to eq('The shortcode cannot be found in the system')
    end
  end
end

def parse_json(response)
  JSON(response.body)
end
