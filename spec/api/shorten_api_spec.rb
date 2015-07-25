require 'rails_helper'

describe Shorty::API do
  describe "POST /shorten" do
    let(:short_code) { create(:short_code) }

    it 'with valid URL' do
      expect_any_instance_of(ShortCode).to receive(:generate).and_return('testcode')
      post '/shorten', url: 'http://google.com'

      expect(response.status).to eq(201)
      expect(response.header['Content-Type']).to eq('application/json')

      json = JSON.parse response.body
      expect(json["shortcode"]).to eq 'testcode'
    end

    it 'missing URL' do
      post '/shorten'

      expect(response.status).to eq(400)
      expect(response.header['Content-Type']).to eq('application/json')
    end

    it 'invalid shortcode URL' do
      post '/shorten', url: 'http://google.com', shortcode: '*)&^*'

      expect(response.status).to eq(422)
      expect(response.header['Content-Type']).to eq('application/json')
    end

    it 'valid shortcode URL' do
      post '/shorten', url: 'http://google.com', shortcode: 'abcd'

      expect(response.status).to eq(201)
      expect(response.header['Content-Type']).to eq('application/json')
    end

    it 'use shortcode' do
      post '/shorten', url: 'http://google.com', shortcode: 'abcd'

      json = JSON.parse response.body
      expect(json["shortcode"]).to eq 'abcd'

      expect(response.status).to eq(201)
      expect(response.header['Content-Type']).to eq('application/json')
    end

    it 'Duplicate shortcode fail' do
      post '/shorten', url: 'http://google.com', shortcode: 'alpha'
      post '/shorten', url: 'http://google.com', shortcode: 'alphA'

      expect(response.status).to eq(409)
      expect(response.header['Content-Type']).to eq('application/json')
    end
  end
  describe "GET /:shortcode" do
    it 'redirect on shortcode' do
      post '/shorten', url: 'http://google.com.au', shortcode: 'valid'
      get '/valid'

      expect(response.status).to eq(302)
      expect(response.header['Content-Type']).to eq('application/json')
      expect(response.header['Location']).to eq('http://google.com.au')
    end

    it 'increment counter' do
      post '/shorten', url: 'http://google.com.au', shortcode: 'counter'
      expect(response.status).to eq(201)
      expect(ShortCode.find_by_shortcode('counter').hits).to eq 0

      get '/counter'
      expect(ShortCode.find_by_shortcode('counter').hits).to eq 1

      expect(response.status).to eq(302)
      expect(response.header['Content-Type']).to eq('application/json')
      expect(response.header['Location']).to eq('http://google.com.au')
    end

    it 'invalid shortcode' do
      get '/invalid'

      expect(response.status).to eq(404)
      expect(response.header['Content-Type']).to eq('application/json')
    end
  end
  describe "GET /:shortcode/code" do
    it 'get shortcode stats' do
      post '/shorten', url: 'http://google.com.au', shortcode: 'statsget'

      # Increment counter
      get '/statsget'
      get '/statsget/stats'

      sc = ShortCode.find_by_shortcode('statsget')
      stats = {
        "startDate" => sc.created_at,
        "lastSeenDate" => sc.updated_at,
        "redirectCount" => 1
      }

      expect(response.status).to eq(200)
      expect(response.header['Content-Type']).to eq('application/json')
      expect(response.body).to eq stats.to_json
    end
  end
end

