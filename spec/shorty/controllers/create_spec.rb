require 'spec_helper'

describe Shorty::Controllers::Create do
  let(:app) { Shorty::Application.router }

  describe '#call,  POST /shorten' do
    context 'given only the url' do
      before do
        post '/shorten', {'url' => 'google.com'}
      end

      it 'responds with 201 code' do
        expect(last_response.status).to eq(201)
      end

      it 'responds with url and shortcode body' do
        expected_body = {url: 'google.com', shortcode: 'a5f635'}.to_json
        expect(last_response.body).to eq(expected_body)
      end
    end

    context 'without url' do
      before do
        post '/shorten'
      end

      it 'responds with 400 code' do
        expect(last_response.status).to eq(400)
      end

      it 'responds with error description body' do
        expected_body = {description: 'url is not present'}.to_json
        expect(last_response.body).to eq(expected_body)
      end
    end

    context 'given an existing shortcode' do
      before do
        post '/shorten', {'url' => 'google.com', 'shortcode' => 'd2LvoD'}
        post '/shorten', {'url' => 'facebook.com', 'shortcode' => 'd2LvoD'}
      end

      it 'responds with 409 code' do
        expect(last_response.status).to eq(409)
      end

      it 'responds with error description body' do
        expected_body = {
          description: 'The the desired shortcode is already in use. Shortcodes are case-sensitive.'
        }.to_json
        expect(last_response.body).to eq(expected_body)
      end
    end

    context 'given an invalid shortcode' do
      before do
        post '/shorten', {'url' => 'facebook.com', 'shortcode' => 'P4'}
      end

      it 'responds with 422 code' do
        expect(last_response.status).to eq(422)
      end

      it 'responds with error description body' do
        expected_body = {
          description: 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'
        }.to_json
        expect(last_response.body).to eq(expected_body)
      end
    end
  end
end
