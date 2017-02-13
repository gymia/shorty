require 'spec_helper'

describe Shorty::Controllers::Show do
  let(:app) { Shorty::Application.router }

  describe '#call,  GET /:shorten/stats' do
    context 'given a brand new shortcode' do
      before do
        Shorty::Models::Shorty.new(url: 'google.com', shortcode: '111111').create
        get '/111111/stats'
      end

      it 'responds with 200 code' do
        expect(last_response.status).to eq(200)
      end

      it 'has 0 redirects' do
        body = JSON.parse(last_response.body).symbolize_keys
        expect(body[:redirectCount]).to eq(0)
      end

      it 'has no last seen date' do
        body = JSON.parse(last_response.body).symbolize_keys
        expect(body.keys).to_not include(:lastSeenDate)
      end
    end

    context 'given a shortcode with 3 redirects' do
    end
  end
end
