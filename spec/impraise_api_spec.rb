require_relative 'spec_helper'
describe Impraise::API do
  include Rack::Test::Methods

  def app
    Impraise::API
  end

  context "API" do
    context 'POST posting a new shortcode' do
      it 'with no url returns 400' do
        post 'shorten', {url: ''}
        expect(last_response.status).to eq(400)
      end

      it 'that already exists fails with appropriate error' do
        ShortcodeData.create!(shortcode: 'aaaa', url: 'http://www.google.com')
        post 'shorten', {shortcode: 'aaaa', url: 'http://www.yahoo.com'}.to_json,{ 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(409)
      end

      it 'with bad shortcode form fails with appropriate error' do
        post 'shorten', {shortcode: 'aaa', url: 'http://www.yahoo.com'}.to_json, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(422)
      end

      it 'should succeed and return shortcode if url, regexp is good and doesnt already exist' do
        post 'shorten', {shortcode: 'abcde', url: 'http://www.yahoo.com'}.to_json, {'CONTENT_TYPE'=> 'application/json'}
        expect(last_response.status).to eq(201)
        expect(JSON.parse(last_response.body)['shortcode']).to eq('abcde')
      end
    end

    context 'POST posting without shortcode' do
      it 'will create new shortcode data and generate a new token if one wasnt given in the params' do
        post 'shorten', {url: 'http://www.yahoo.com'}.to_json, {'CONTENT_TYPE'=> 'application/json'}
        expect(last_response.status).to eq(201)
        shortcode = (JSON.parse(last_response.body))['shortcode']
        expect(shortcode.length).to eq(6)
      end
    end

    context 'GET :shortcode' do
      context 'shortcode doesnt exist' do
        it 'will return 404 if shortcode doesnt exist' do
          get '/blahblah'
          expect(last_response.status).to eq(404)
        end
        it 'will redirect to url if shortcode exists' do
          code = ShortcodeData.create!(shortcode: 'aaaa', url: 'http://www.google.com')
          get '/aaaa'
          expect(last_response.status).to eq(302)
          expect(last_response.body).to include(code.url)
        end
      end

      context 'last seen' do
        it 'will update last_seen' do
          code = ShortcodeData.create!(shortcode: 'aaaa', url: 'http://www.google.com')
          expect(code.last_seen_date).to_not be_present
          get '/aaaa'
          code = code.reload
          expect((code.last_seen_date).to_date).to eq(Date.today)
          get '/aaaa/stats'
          expect((JSON.parse(last_response.body))['lastSeenDate'].to_date).to eq(Date.today)
        end
      end

      context 'redirect_count' do
        it 'will increment redirect_count' do
          code = ShortcodeData.create!(shortcode: 'aaaa', url: 'http://www.google.com')
          expect(code.redirect_count).to eq(0)
          get '/aaaa'
          code = code.reload
          expect((code.redirect_count)).to eq(1)
        end
      end
    end

    context 'GET :shortcode/stats' do
      it 'should show stats of shortcode' do
        code = ShortcodeData.create!(shortcode: 'aaaa', url: 'http://www.google.com')
        get "/#{code.shortcode}/stats"
        json = JSON.parse(last_response.body)
        expect(json['redirectCount']).to eq(0)
        expect(json['startDate'].to_date).to eq(code.start_date.to_date)
        expect(json['lastSeenDate']).to be_nil
      end
    end
  end

  context 'Model' do
    context 'not valid' do
      it 'is not valid if shortcode too short' do
        code = ShortcodeData.new(url: 'htawszzz', shortcode: 'aaa')
        code.validate
        expect(code.errors.full_messages).to include('Shortcode is invalid')
      end
      it 'is not valid if shortcode has non alphanumeric' do
        code = ShortcodeData.new(url: 'aasdasdasd@@', shortcode: 'aaa')
        code.validate
        expect(code.errors.full_messages).to include('Shortcode is invalid')
      end
      it 'is not valid if url is missing' do
        code = ShortcodeData.new(url: '', shortcode: 'aaaa')
        code.validate
        expect(code.errors.full_messages).to include("Url can't be blank")
      end
    end

    context 'valid' do
      it 'should be valid if provided url and alphanumeric shortcode' do
        code = ShortcodeData.new(url: 'http://www.google.com', shortcode: 'aaaaQQ12345ff')
        expect(code.valid?).to be_truthy
      end

      it 'should generate valid shortcode of exactly 6 chars if non was given' do
        code = ShortcodeData.new(url: 'http://www.google.com')
        expect(code.shortcode.length).to eq(6)
      end

      it 'shouldnt override shortcode if shortcode was given' do
        code = ShortcodeData.new(url: 'http://www.google.com', shortcode: 'aaaaQQ12345ff')
        expect(code.shortcode).to eq('aaaaQQ12345ff')
      end
    end
  end

end