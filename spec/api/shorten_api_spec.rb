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
  end
end

