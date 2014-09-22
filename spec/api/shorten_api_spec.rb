require 'rails_helper'

describe Shorty::API do
 describe "POST /shorten" do
   it 'with valid URL' do
     post '/shorten', url: 'http://google.com'
     expect(response.status).to eq(201)
   end
 end
end

