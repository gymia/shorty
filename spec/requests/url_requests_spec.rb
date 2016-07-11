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
      it 'creates an url register with the desired short code' do
        post :shorten, params: { url: 'http://www.google.com/', shortcode: 'asdf' }

        expect(response.status).to eq(201)
        expect(assigns(:url).url).to eq('http://www.google.com/')
        expect(assigns(:url).short_code).to eq('asdf')

        json = JSON.parse(response.body)
        expect(json['shortcode']).to eq('asdf')
      end

      it 'generates a random short code when it is not passed as a parameter' do
        post :shorten, params: { url: 'http://www.google.com/', shortcode: nil }

        expect(response.status).to eq(201)
        expect(assigns(:url).url).to eq('http://www.google.com/')

        json = JSON.parse(response.body)
        expect(json['shortcode']).to eq(assigns(:url).short_code)
        expect(json['shortcode']).to match(/\A[0-9a-zA-Z_]{6}\z/)
      end

      it 'is case sensitive for new shortcode registers' do
        create :url, short_code: 'asdf'

        post :shorten, params: { url: 'http://www.facebook.com/', shortcode: 'AsDf' }

        expect(response.status).to eq(201)
        expect(assigns(:url).url).to eq('http://www.facebook.com/')
        expect(assigns(:url).short_code).to eq('AsDf')

        json = JSON.parse(response.body)
        expect(json['shortcode']).to eq('AsDf')
      end
    end
  end

  describe '#short_code' do
    context 'when the url could not be found with the given short_code' do
      it 'raises an error and returns a 404 error' do
        get :short_code, params: { shortcode: 'asdf' }

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('The shortcode cannot be found in the system.')
      end
    end

    context 'when the url is found by the given short_code' do
      let(:current_time) { Time.parse('Feb 24 1981') }
      before(:each) { allow(Time).to receive(:current).and_return(current_time) }

      it 'update the register properties and redirects to the url' do
        create :url, short_code: 'asdf', url: 'http://www.google.com/', redirect_count: 0

        get :short_code, params: { shortcode: 'asdf' }

        expect(response.status).to eq(302)
        expect(request).to redirect_to('http://www.google.com/')
        expect(assigns(:url).redirect_count).to eq(1)
      end
    end
  end

  describe '#stats' do
    context 'when the url could not be found with the given short_code' do
      it 'raises an error and returns a 404 error' do
        get :stats, params: { shortcode: 'asdf' }

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('The shortcode cannot be found in the system.')
      end
    end

    context 'when the url is found by the given short_code' do
      let(:current_time) { Time.parse('Feb 24 1981') }
      let!(:url) { create :url, url: 'http://www.google.com/', short_code: 'asdf', created_at: current_time, updated_at: current_time }

      context 'when the register does not have redirects' do
        it 'returns the stats for a given register with blank lastSeenDate field' do
          get :stats, params: { shortcode: 'asdf' }

          expect(response.status).to eq(200)
          json = JSON.parse(response.body)
          expect(json['startDate']).to eq(url.created_at.iso8601(3))
          expect(json['lastSeenDate']).to eq(nil)
          expect(json['redirectCount']).to eq(0)
        end
      end

      context 'when the register has redirects' do
        it 'returns the stats for a given register with blank lastSeenDate field' do
          url.update_column(:redirect_count, 1)

          get :stats, params: { shortcode: 'asdf' }

          expect(response.status).to eq(200)
          json = JSON.parse(response.body)
          expect(json['startDate']).to eq(url.created_at.iso8601(3))
          expect(json['lastSeenDate']).to eq(url.updated_at.iso8601(3))
          expect(json['redirectCount']).to eq(1)
        end
      end
    end
  end
end
