require 'rails_helper'

describe Shorty::API do
  describe "POST /shorten" do
    let(:short_code) { create(:short_code) }

    it 'with valid URL' do
      post '/shorten', url: 'http://google.com'
      body = { shortcode: ''}

      expect(response.status).to eq(201)
      expect(response.header['Content-Type']).to eq('application/json')
      expect(response.body).to eq body.to_json
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
  end
end

