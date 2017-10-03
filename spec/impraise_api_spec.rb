
describe Impraise::API do
  include Rack::Test::Methods

  def app
    Impraise::API
  end

  context 'GET /api/statuses/public_timeline' do
    it 'returns an empty array of statuses' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq []
    end
  end

end