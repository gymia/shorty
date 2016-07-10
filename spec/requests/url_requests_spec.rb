require 'rails_helper'

describe UrlsController, type: :controller do
  describe '#shorten' do
    context 'when the url parameter is not present' do
      it 'returns a 400 error' do
        post :shorten, params: { url: nil, shortcode: 'asdf' }

        expect(response.status).to eq(400)

        json = JSON.parse(response.body)
        expect(json['error']).to eq('Url is not present.')
      end
    end

    context 'when the shortcode parameter is already on use' do
      it 'returns a 409 error' do
        create :url, short_code: 'asdf'

        post :shorten, params: { url: 'http://www.google.com/', shortcode: 'asdf' }

        expect(response.status).to eq(409)

        json = JSON.parse(response.body)
        expect(json['error']).to eq('The the desired shortcode is already in use.')
      end
    end

    context 'when the shortcode parameter is on an invalid format' do
      it 'returns a 422 error' do
        post :shorten, params: { url: 'http://www.google.com/', shortcode: 'asd' }

        expect(response.status).to eq(422)

        json = JSON.parse(response.body)
        expect(json['error']).to eq('The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.')
      end
    end

    context 'when the parameters are valid' do
      let!(:current_time) { Time.parse('Feb 24 1981') }
      before(:each) { allow(Time).to receive(:current).and_return(current_time) }

      it 'creates an url register with the desired short code' do
        post :shorten, params: { url: 'http://www.google.com/', shortcode: 'asdf' }

        expect(response.status).to eq(201)
        expect(assigns(:url).url).to eq('http://www.google.com/')
        expect(assigns(:url).short_code).to eq('asdf')
        expect(assigns(:url).start_date).to eq(current_time)

        json = JSON.parse(response.body)
        expect(json['shortcode']).to eq('asdf')
      end

      it 'generates a random short code when it is not passed as a parameter' do
        post :shorten, params: { url: 'http://www.google.com/', shortcode: nil }

        expect(response.status).to eq(201)
        expect(assigns(:url).url).to eq('http://www.google.com/')
        expect(assigns(:url).start_date).to eq(current_time)

        json = JSON.parse(response.body)
        expect(json['shortcode']).to eq(assigns(:url).short_code)
      end

      it 'is case sensitive for new shortcode registers' do
        create :url, short_code: 'asdf'

        post :shorten, params: { url: 'http://www.facebook.com/', shortcode: 'AsDf' }

        expect(response.status).to eq(201)
        expect(assigns(:url).url).to eq('http://www.facebook.com/')
        expect(assigns(:url).short_code).to eq('AsDf')
        expect(assigns(:url).start_date).to eq(current_time)

        json = JSON.parse(response.body)
        expect(json['shortcode']).to eq('AsDf')
      end
    end
  end

  describe '#short_code' do

  end

  describe '#stats' do

  end
end
