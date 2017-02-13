require 'spec_helper'

describe Shorty::Controllers::Show do
  let(:app) { Shorty::Application.router }

  describe '#call,  GET /:shorten' do
    context 'given an existing shortcode' do
      before do
        Shorty::Models::Shorty.new(url: 'abc.com', shortcode: '777777').create
        get '/777777'
      end

      it 'responds with 302 code' do
        expect(last_response.status).to eq(302)
      end

      it 'responds with shortned url on Location header' do
        expected_location = { 'Location' => 'http://777777' }
        expect(last_response.header).to include(expected_location)
      end

      it 'increments redirect of the shorty model instance' do
        expect_any_instance_of(Shorty::Models::Shorty).to receive(:increment_redirect)
        get '/777777'
      end
    end

    context 'given an unexistent shortcode' do
      before do
        get '/123456'
      end

      it 'responds with 404 code' do
        expect(last_response.status).to eq(404)
      end

      it 'responds with error description body' do
        expected_body = {
          description: 'The shortcode cannot be found in the system'
        }.to_json
        expect(last_response.body).to eq(expected_body)
      end
    end
  end
end
